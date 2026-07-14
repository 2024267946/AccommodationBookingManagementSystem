package util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public final class AccommodationImageStore {
    private static final Object LOCK = new Object();
    private static final Pattern ENTRY = Pattern.compile(
            "\\\"((?:\\\\.|[^\\\"])*)\\\"\\s*:\\s*\\[(.*?)]", Pattern.DOTALL);
    private static final Pattern VALUE = Pattern.compile("\\\"((?:\\\\.|[^\\\"])*)\\\"");
    private static final Set<String> EXTENSIONS = Set.of("jpg", "jpeg", "png", "gif", "webp");

    private AccommodationImageStore() {}

    public static Map<String, List<String>> loadAll() {
        synchronized (LOCK) {
            return readIndex();
        }
    }

    public static List<String> getImages(String accommodationId) {
        if (accommodationId == null) return List.of();
        return loadAll().getOrDefault(accommodationId, List.of());
    }

    public static int saveUploadedImages(HttpServletRequest request, String accommodationId)
            throws Exception {
        return saveUploadedImages(request, accommodationId, false);
    }

    public static int replaceUploadedImages(HttpServletRequest request, String accommodationId)
            throws Exception {
        return saveUploadedImages(request, accommodationId, true);
    }

    private static int saveUploadedImages(HttpServletRequest request, String accommodationId,
            boolean replaceExisting) throws Exception {
        if (accommodationId == null || !accommodationId.matches("[A-Za-z0-9_-]+")) return 0;
        List<Part> imageParts = new ArrayList<>();
        for (Part part : request.getParts()) {
            if ("accommodationImages".equals(part.getName()) && part.getSize() > 0) {
                imageParts.add(part);
            }
        }
        if (imageParts.isEmpty()) return 0;

        synchronized (LOCK) {
            Map<String, List<String>> index = readIndex();
            List<String> previousImages = new ArrayList<>(
                    index.getOrDefault(accommodationId, List.of()));
            List<String> images = replaceExisting
                    ? new ArrayList<>() : new ArrayList<>(previousImages);
            Path directory = root().resolve("accommodation-images").resolve(accommodationId);
            Files.createDirectories(directory);

            for (Part part : imageParts) {
                String submitted = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                String extension = extension(submitted);
                String contentType = part.getContentType();
                if (!EXTENSIONS.contains(extension)
                        || contentType == null || !contentType.toLowerCase(Locale.ROOT).startsWith("image/")) {
                    throw new IOException("Only JPG, PNG, GIF and WEBP images are supported");
                }
                String base = submitted.substring(0, submitted.length() - extension.length() - 1)
                        .replaceAll("[^A-Za-z0-9_-]+", "-");
                if (base.isBlank()) base = "image";
                String filename = System.currentTimeMillis() + "-" + UUID.randomUUID().toString().substring(0, 8)
                        + "-" + base + "." + extension;
                Path target = directory.resolve(filename).normalize();
                try (InputStream input = part.getInputStream()) {
                    Files.copy(input, target, StandardCopyOption.REPLACE_EXISTING);
                }
                images.add("accommodation-images/" + accommodationId + "/" + filename);
            }
            index.put(accommodationId, images);
            writeIndex(index);
            if (replaceExisting) {
                Path projectRoot = root().toAbsolutePath().normalize();
                for (String previous : previousImages) {
                    Path oldImage = projectRoot.resolve(previous).normalize();
                    if (oldImage.startsWith(projectRoot.resolve("accommodation-images"))
                            && !images.contains(previous)) {
                        Files.deleteIfExists(oldImage);
                    }
                }
            }
            return imageParts.size();
        }
    }

    public static Path resolveStoredImage(String accommodationId, int index) {
        List<String> images = getImages(accommodationId);
        if (index < 0 || index >= images.size()) return null;
        Path projectRoot = root().toAbsolutePath().normalize();
        Path image = projectRoot.resolve(images.get(index)).normalize();
        return image.startsWith(projectRoot.resolve("accommodation-images")) && Files.isRegularFile(image)
                ? image : null;
    }

    private static Map<String, List<String>> readIndex() {
        Map<String, List<String>> result = new LinkedHashMap<>();
        Path file = root().resolve("accommodation-images.json");
        if (!Files.exists(file)) return result;
        try {
            String json = Files.readString(file, StandardCharsets.UTF_8);
            Matcher entries = ENTRY.matcher(json);
            while (entries.find()) {
                String key = unescape(entries.group(1));
                List<String> values = new ArrayList<>();
                Matcher valueMatcher = VALUE.matcher(entries.group(2));
                while (valueMatcher.find()) values.add(unescape(valueMatcher.group(1)));
                result.put(key, values);
            }
        } catch (IOException e) {
            throw new IllegalStateException("Unable to read accommodation-images.json", e);
        }
        return result;
    }

    private static void writeIndex(Map<String, List<String>> index) throws IOException {
        StringBuilder json = new StringBuilder("{\n");
        Iterator<Map.Entry<String, List<String>>> entries = index.entrySet().iterator();
        while (entries.hasNext()) {
            Map.Entry<String, List<String>> entry = entries.next();
            json.append("  \"").append(escape(entry.getKey())).append("\": [");
            for (int i = 0; i < entry.getValue().size(); i++) {
                if (i > 0) json.append(", ");
                json.append("\"").append(escape(entry.getValue().get(i))).append("\"");
            }
            json.append(']');
            if (entries.hasNext()) json.append(',');
            json.append('\n');
        }
        json.append("}\n");
        Path target = root().resolve("accommodation-images.json");
        Path temporary = root().resolve("accommodation-images.json.tmp");
        Files.writeString(temporary, json, StandardCharsets.UTF_8,
                StandardOpenOption.CREATE, StandardOpenOption.TRUNCATE_EXISTING);
        try {
            Files.move(temporary, target, StandardCopyOption.REPLACE_EXISTING,
                    StandardCopyOption.ATOMIC_MOVE);
        } catch (AtomicMoveNotSupportedException e) {
            Files.move(temporary, target, StandardCopyOption.REPLACE_EXISTING);
        }
    }

    private static Path root() {
        String configured = System.getProperty("cmm.project.root");
        if (configured == null || configured.isBlank()) configured = System.getenv("CMM_PROJECT_ROOT");
        if (configured != null && !configured.isBlank()) return Paths.get(configured).toAbsolutePath();
        Path current = Paths.get(System.getProperty("user.dir")).toAbsolutePath();
        for (Path candidate = current; candidate != null; candidate = candidate.getParent()) {
            if (Files.exists(candidate.resolve("pom.xml"))) return candidate;
        }
        Path localProject = Paths.get(System.getProperty("user.home"),
                "Desktop", "Self_Project", "alyasystem");
        if (Files.exists(localProject.resolve("pom.xml"))) return localProject;
        throw new IllegalStateException("Project root not found. Set CMM_PROJECT_ROOT.");
    }

    private static String extension(String filename) {
        int dot = filename.lastIndexOf('.');
        return dot < 0 ? "" : filename.substring(dot + 1).toLowerCase(Locale.ROOT);
    }

    private static String escape(String value) {
        return value.replace("\\", "\\\\").replace("\"", "\\\"");
    }

    private static String unescape(String value) {
        return value.replace("\\\"", "\"").replace("\\\\", "\\");
    }
}

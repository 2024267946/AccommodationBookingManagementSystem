package model;

import java.io.FileWriter;
import java.io.IOException;

public class Logger {

    public static void log(String message) {
        try {
            FileWriter writer = new FileWriter("/Users/fareeqshahfitri/Desktop/Self_Project/alyasystem/debug.log", true);
            writer.write(message + "\n");
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
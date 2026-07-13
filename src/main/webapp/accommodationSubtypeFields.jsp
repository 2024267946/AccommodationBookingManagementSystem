<%@ page import="java.util.Map" %>
<%
    Map<String, String> subtypeDetails =
            (Map<String, String>) request.getAttribute("subtypeDetails");
    if (subtypeDetails == null) subtypeDetails = new java.util.HashMap<>();
%>
<style>
    .subtype-fields{display:none;grid-column:1/-1;grid-template-columns:repeat(2,minmax(0,1fr));gap:20px;padding:20px;border:1px solid #dce8e3;border-radius:12px;background:#f6faf8}
    .subtype-fields.visible{display:grid}.subtype-title{grid-column:1/-1;margin:0;color:#174a3c;font-size:18px}
    @media(max-width:768px){.subtype-fields{grid-template-columns:1fr}.subtype-title{grid-column:auto}}
</style>
<div id="homestayFields" class="subtype-fields">
    <h3 class="subtype-title">Homestay Details</h3>
    <div class="form-group"><label>Number of Rooms</label>
        <input class="form-control subtype-input" type="number" name="numberOfRooms" min="1"
               value="<%= subtypeDetails.getOrDefault("numberOfRooms", "") %>"></div>
    <div class="form-group"><label>Has Living Hall</label>
        <select class="form-control subtype-input" name="hasLivingHall">
            <option value="">-- Select --</option>
            <option value="YES" <%= "YES".equalsIgnoreCase(subtypeDetails.get("hasLivingHall")) ? "selected" : "" %>>Yes</option>
            <option value="NO" <%= "NO".equalsIgnoreCase(subtypeDetails.get("hasLivingHall")) ? "selected" : "" %>>No</option>
        </select></div>
</div>
<div id="chaletFields" class="subtype-fields">
    <h3 class="subtype-title">Chalet Details</h3>
    <div class="form-group"><label>Room Number</label>
        <input class="form-control subtype-input" type="text" name="roomNumber" maxlength="20"
               value="<%= subtypeDetails.getOrDefault("roomNumber", "") %>"></div>
    <div class="form-group"><label>Floor Level</label>
        <input class="form-control subtype-input" type="text" name="floorLevel" maxlength="20"
               value="<%= subtypeDetails.getOrDefault("floorLevel", "") %>"></div>
    <div class="form-group"><label>Chalet Category</label>
        <select class="form-control subtype-input" name="chaletCategory">
            <option value="">-- Select Category --</option>
            <% for (String category : new String[]{"STANDARD", "PREMIUM", "LUXURY"}) { %>
                <option value="<%= category %>" <%= category.equalsIgnoreCase(subtypeDetails.get("chaletCategory")) ? "selected" : "" %>><%= category.substring(0,1) + category.substring(1).toLowerCase() %></option>
            <% } %>
        </select></div>
</div>
<script>
document.addEventListener("DOMContentLoaded",function(){
    const type=document.querySelector('[name="accommodationType"]');
    const home=document.getElementById("homestayFields"),chalet=document.getElementById("chaletFields");
    function updateSubtype(){
        const isHome=type.value==="HOMESTAY",isChalet=type.value==="CHALET";
        home.classList.toggle("visible",isHome);chalet.classList.toggle("visible",isChalet);
        home.querySelectorAll(".subtype-input").forEach(f=>{f.required=isHome;f.disabled=!isHome});
        chalet.querySelectorAll(".subtype-input").forEach(f=>{f.required=isChalet;f.disabled=!isChalet});
    }
    type.addEventListener("change",updateSubtype);updateSubtype();
});
</script>

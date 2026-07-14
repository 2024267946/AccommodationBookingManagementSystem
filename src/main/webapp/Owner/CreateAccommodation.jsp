<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Accommodation | Owner</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css">

    <style>
        .form-page {
            max-width: 1120px;
            margin: 0;
        }

        .form-card {
            background: #ffffff;
            border: 1px solid #e7dfd5;
            border-radius: 16px;
            padding: 32px;
            box-shadow: 0 4px 14px rgba(0, 0, 0, 0.06);
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 22px 26px;
        }

        .form-group {
            margin: 0;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-group label {
            display: block;
            margin-bottom: 9px;
            font-weight: 600;
            color: #171717;
        }

        .form-control {
            width: 100%;
            box-sizing: border-box;
            padding: 14px 16px;
            border: 1px solid #d9d1c7;
            border-radius: 10px;
            background: #ffffff;
            font: inherit;
            color: #222222;
            outline: none;
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
        }

        .form-control:focus {
            border-color: #163f34;
            box-shadow: 0 0 0 4px rgba(22, 63, 52, 0.10);
        }

        .subtype-fields {
            display: none;
            grid-column: 1 / -1;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 22px 26px;
            padding: 22px;
            border: 1px solid #dce8e3;
            border-radius: 12px;
            background: #f6faf8;
        }

        .subtype-fields.visible { display: grid; }

        .subtype-title {
            grid-column: 1 / -1;
            margin: 0;
            color: #174a3c;
            font-size: 18px;
        }

        textarea.form-control {
            min-height: 130px;
            resize: vertical;
        }

        .readonly-input {
            background: #f5f2ed;
            color: #555555;
        }

        .form-actions {
            display: flex;
            align-items: center;
            gap: 14px;
            flex-wrap: wrap;
            margin-top: 28px;
        }

        .page-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-height: 48px;
            padding: 0 26px;
            border: 0;
            border-radius: 8px;
            font: inherit;
            font-weight: 700;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            text-decoration: none;
            cursor: pointer;
        }

        .page-btn-primary {
            background: #003d2f;
            color: #ffffff;
        }

        .page-btn-secondary {
            background: #eee9e1;
            color: #4d4a46;
        }

        .message {
            margin-bottom: 24px;
            padding: 16px 20px;
            border-radius: 10px;
            font-weight: 600;
        }

        .message-error {
            color: #a61b1b;
            background: #fff0f0;
            border: 1px solid #f3b7b7;
        }

        .message-success {
            color: #17633a;
            background: #eef9f2;
            border: 1px solid #b8dfc7;
        }

        @media (max-width: 800px) {
            .form-grid {
                grid-template-columns: 1fr;
            }

            .form-group.full-width {
                grid-column: auto;
            }

            .subtype-fields { grid-template-columns: 1fr; }
            .subtype-title { grid-column: auto; }

            .form-card {
                padding: 22px;
            }

            .page-btn {
                width: 100%;
            }
        }
    </style>

</head>

<body class="admin-body">

<jsp:include page="ownerNavbar.jsp" />

<div class="admin-layout">

    <jsp:include page="sidebar.jsp" />

    <main class="main-content">

        <div class="container form-page">

            <div class="page-header" style="text-align:left; margin-bottom:28px;">
                <h1>Create Accommodation</h1>
                <p class="text-muted">
                    Add a new accommodation to DG Rimbun Homestay.
                </p>
            </div>

            <%
                String error = request.getParameter("error");

                if ("emptyField".equals(error)) {
            %>
                <div class="message message-error">Please fill in all fields.</div>
            <%
                } else if ("invalidNumber".equals(error)) {
            %>
                <div class="message message-error">
                    Capacity and price must be valid numbers.
                </div>
            <%
                } else if ("createFailed".equals(error)) {
            %>
                <div class="message message-error">
                    Failed to create accommodation.
                </div>
            <%
                } else if ("subtypeField".equals(error)) {
            %>
                <div class="message message-error">
                    Please complete all fields required for the selected accommodation type.
                </div>
            <%
                } else if ("systemError".equals(error)) {
            %>
                <div class="message message-error">
                    A system error occurred. Please try again.
                </div>
            <%
                }
            %>

            <div class="form-card">

                <form action="${pageContext.request.contextPath}/CreateAccommodationServlet"
                      method="post" enctype="multipart/form-data">

                    <div class="form-grid">

                        <div class="form-group full-width">
                            <label for="accommodationName">Accommodation Name</label>
                            <input id="accommodationName"
                                   class="form-control"
                                   type="text"
                                   name="accommodationName"
                                   placeholder="Enter accommodation name"
                                   required>
                        </div>

                        <div class="form-group">
                            <label for="accommodationType">Accommodation Type</label>
                            <select id="accommodationType"
                                    class="form-control"
                                    name="accommodationType"
                                    required>
                                <option value="">-- Select Type --</option>
                                <option value="CHALET">CHALET</option>
                                <option value="HOMESTAY">HOMESTAY</option>
                            </select>
                        </div>

                        <div id="homestayFields" class="subtype-fields">
                            <h3 class="subtype-title">Homestay Details</h3>
                            <div class="form-group">
                                <label for="numberOfRooms">Number of Rooms</label>
                                <input id="numberOfRooms" class="form-control subtype-input"
                                       type="number" name="numberOfRooms" min="1"
                                       placeholder="Enter number of rooms">
                            </div>
                            <div class="form-group">
                                <label for="hasLivingHall">Has Living Hall</label>
                                <select id="hasLivingHall" class="form-control subtype-input"
                                        name="hasLivingHall">
                                    <option value="">-- Select --</option>
                                    <option value="YES">Yes</option>
                                    <option value="NO">No</option>
                                </select>
                            </div>
                        </div>

                        <div id="chaletFields" class="subtype-fields">
                            <h3 class="subtype-title">Chalet Details</h3>
                            <div class="form-group">
                                <label for="roomNumber">Room Number</label>
                                <input id="roomNumber" class="form-control subtype-input"
                                       type="text" name="roomNumber" maxlength="20"
                                       placeholder="Example: C101">
                            </div>
                            <div class="form-group">
                                <label for="floorLevel">Floor Level</label>
                                <input id="floorLevel" class="form-control subtype-input"
                                       type="text" name="floorLevel" maxlength="20"
                                       placeholder="Example: 1">
                            </div>
                            <div class="form-group">
                                <label for="chaletCategory">Chalet Category</label>
                                <select id="chaletCategory" class="form-control subtype-input"
                                        name="chaletCategory">
                                    <option value="">-- Select Category --</option>
                                    <option value="STANDARD">Standard</option>
                                    <option value="PREMIUM">Premium</option>
                                    <option value="LUXURY">Luxury</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="maxCapacity">Maximum Capacity</label>
                            <input id="maxCapacity"
                                   class="form-control"
                                   type="number"
                                   name="maxCapacity"
                                   min="1"
                                   placeholder="Enter maximum capacity"
                                   required>
                        </div>

                        <div class="form-group">
                            <label for="pricePerNight">Price Per Night (RM)</label>
                            <input id="pricePerNight"
                                   class="form-control"
                                   type="number"
                                   step="0.01"
                                   min="0"
                                   name="pricePerNight"
                                   placeholder="Enter price per night"
                                   required>
                        </div>

                        <div class="form-group">
                            <label for="location">Location</label>
                            <input id="location"
                                   class="form-control"
                                   type="text"
                                   name="location"
                                   placeholder="Enter accommodation location"
                                   required>
                        </div>

                        <div class="form-group full-width">
                            <label for="description">Description</label>
                            <textarea id="description"
                                      class="form-control"
                                      name="description"
                                      placeholder="Enter accommodation description"
                                      required></textarea>
                        </div>

                        <div class="form-group full-width">
                            <label for="accommodationImages">Accommodation Pictures</label>
                            <input id="accommodationImages" class="form-control" type="file"
                                   name="accommodationImages" accept="image/jpeg,image/png,image/gif,image/webp"
                                   multiple>
                            <small class="text-muted">Choose one or more JPG, PNG, GIF or WEBP pictures (maximum 10 MB each).</small>
                        </div>

                    </div>

                    <div class="form-actions">
                        <button type="submit"
                                class="page-btn page-btn-primary">
                            Save
                        </button>

                        <a href="${pageContext.request.contextPath}/OwnerAccommodationListServlet"
                           class="page-btn page-btn-secondary">
                            Cancel
                        </a>
                    </div>

                </form>

            </div>

        </div>

    </main>

</div>

<script>
    const accommodationType = document.getElementById("accommodationType");
    const homestayFields = document.getElementById("homestayFields");
    const chaletFields = document.getElementById("chaletFields");

    function setSubtypeVisibility() {
        const selectedType = accommodationType.value;
        const showHomestay = selectedType === "HOMESTAY";
        const showChalet = selectedType === "CHALET";

        homestayFields.classList.toggle("visible", showHomestay);
        chaletFields.classList.toggle("visible", showChalet);

        homestayFields.querySelectorAll(".subtype-input").forEach(function (field) {
            field.required = showHomestay;
            field.disabled = !showHomestay;
        });
        chaletFields.querySelectorAll(".subtype-input").forEach(function (field) {
            field.required = showChalet;
            field.disabled = !showChalet;
        });
    }

    accommodationType.addEventListener("change", setSubtypeVisibility);
    setSubtypeVisibility();
</script>

</body>
</html>

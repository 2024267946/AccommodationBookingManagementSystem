<%@ page pageEncoding="UTF-8" %>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
      rel="stylesheet">

<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
      rel="stylesheet">

<link rel="stylesheet"
      type="text/css"
      href="${pageContext.request.contextPath}/css/style.css">

<link rel="stylesheet"
      type="text/css"
      href="${pageContext.request.contextPath}/css/searchAvailability.css">

<link rel="stylesheet"
      type="text/css"
      href="${pageContext.request.contextPath}/css/theme.css">
<script src="${pageContext.request.contextPath}/js/app-modal.js"></script>

<style>
    .guest-user-nav {
        position: relative;
        z-index: 1000;
        width: 100%;
        background: rgba(255, 255, 255, 0.97);
        border-bottom: 1px solid rgba(14, 30, 25, 0.12);
        box-shadow: 0 4px 16px rgba(14, 30, 25, 0.05);
    }

    .guest-user-nav .guest-nav-inner {
        display: flex;
        align-items: center;
        justify-content: space-between;
        min-height: 82px;
        padding: 12px 42px;
        gap: 30px;
    }

    .guest-user-nav .guest-logo img {
        display: block;
        width: auto;
        height: 50px;
    }

    .guest-user-nav .guest-nav-content {
        display: flex;
        align-items: center;
        justify-content: flex-end;
        gap: 32px;
        flex: 1;
    }

    .guest-user-nav .guest-nav-links {
        display: flex;
        align-items: center;
        gap: 26px;
        margin: 0;
        padding: 0;
        list-style: none;
    }

    .guest-user-nav .guest-nav-link {
        color: #243b34;
        font-size: 14px;
        font-weight: 600;
        text-decoration: none;
        transition: color 0.2s ease;
    }

    .guest-user-nav .guest-nav-link:hover,
    .guest-user-nav .guest-nav-link.active {
        color: #00634d;
    }

    .guest-account-area {
        display: flex;
        align-items: center;
        gap: 14px;
        padding-left: 22px;
        border-left: 1px solid #ddd6cc;
    }

    .guest-welcome {
        display: flex;
        flex-direction: column;
        line-height: 1.2;
    }

    .guest-welcome small {
        color: #7a756f;
        font-size: 11px;
        text-transform: uppercase;
        letter-spacing: 0.08em;
    }

    .guest-welcome strong {
        color: #173f34;
        font-size: 14px;
    }

    .guest-account-button,
    .guest-logout-button {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        min-height: 42px;
        padding: 0 16px;
        border-radius: 8px;
        font-size: 13px;
        font-weight: 700;
        text-decoration: none;
    }

    .guest-account-button {
        color: #173f34;
        background: #eef4f1;
        border: 1px solid #cfddd7;
    }

    .guest-logout-button {
        color: #ffffff;
        background: #003d2f;
    }

    @media (max-width: 950px) {
        .guest-user-nav .guest-nav-inner {
            align-items: flex-start;
            flex-direction: column;
            padding: 18px 24px;
        }

        .guest-user-nav .guest-nav-content {
            align-items: flex-start;
            flex-direction: column;
            width: 100%;
            gap: 18px;
        }

        .guest-user-nav .guest-nav-links {
            flex-wrap: wrap;
        }

        .guest-account-area {
            width: 100%;
            padding-top: 16px;
            padding-left: 0;
            border-top: 1px solid #ddd6cc;
            border-left: 0;
        }
    }
</style>

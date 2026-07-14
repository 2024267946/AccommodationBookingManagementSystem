(function () {
    if (window.__appModalLoaded) return;
    window.__appModalLoaded = true;
    function ensureStyles() {
        if (document.getElementById("app-modal-styles")) return;
        const style = document.createElement("style");
        style.id = "app-modal-styles";
        style.textContent = ".app-modal-overlay{position:fixed;z-index:5000;inset:0;display:flex;align-items:center;justify-content:center;padding:24px;background:rgba(8,28,22,.62)}.app-modal-card{width:min(430px,100%);padding:34px;border-radius:18px;background:#fff;text-align:center;box-shadow:0 24px 70px rgba(0,0,0,.24)}.app-modal-icon{display:flex;align-items:center;justify-content:center;width:62px;height:62px;margin:0 auto 18px;border-radius:50%;background:#fff3e4;color:#9b5e16;font-size:28px;font-weight:bold}.app-modal-card h2{margin:0 0 10px;color:#123a30}.app-modal-card p{margin:0 0 24px;color:#746f69;line-height:1.55}.app-modal-actions{display:flex;justify-content:center;gap:12px;flex-wrap:wrap}.app-modal-button{min-height:43px;padding:0 19px;border:0;border-radius:8px;font:inherit;font-weight:800;cursor:pointer}.app-modal-cancel{background:#eeeae4;color:#4e4a45}.app-modal-confirm{background:#a42b2b;color:#fff}.app-modal-ok{background:#064b3a;color:#fff}.app-password-form{text-align:left}.app-password-field{margin-bottom:15px}.app-password-field label{display:block;margin-bottom:6px;color:#123a30;font-weight:700}.app-password-field input{box-sizing:border-box;width:100%;padding:12px;border:1px solid #d9d4cc;border-radius:8px;font:inherit}.app-password-error{display:none;margin:-5px 0 14px;color:#a61b1b;font-size:.88rem}";
        document.head.appendChild(style);
    }

    window.showAppMessage = function (title, message) {
        return window.showAppNotification(title, message, "error", 3500);
    };

    window.showAppNotification = function (title, message, type, duration) {
        ensureStyles();
        const overlay = build(title, message, type === "success" ? "✓" : "!");
        if (type === "success") overlay.querySelector(".app-modal-icon").style.cssText = "background:#eaf7ef;color:#17633a";
        const actions = overlay.querySelector(".app-modal-actions");
        const ok = button("OK", "app-modal-ok");
        ok.addEventListener("click", function () { overlay.remove(); });
        actions.appendChild(ok);
        document.body.appendChild(overlay);
        window.setTimeout(function () { if (overlay.isConnected) overlay.remove(); }, duration || 3000);
        return overlay;
    };

    window.showPasswordResetModal = function (action) {
        ensureStyles();
        const overlay = build("Reset Password", "Enter your current password, then choose a new password.", "•");
        const card = overlay.querySelector(".app-modal-card");
        const actions = overlay.querySelector(".app-modal-actions");
        const form = document.createElement("form");
        form.className = "app-password-form";
        form.method = "post";
        form.action = action;
        function field(label, name) {
            const wrapper = document.createElement("div"); wrapper.className = "app-password-field";
            const labelNode = document.createElement("label"); labelNode.textContent = label;
            const input = document.createElement("input"); input.type = "password"; input.name = name;
            input.required = true; if (name !== "currentPassword") input.minLength = 6;
            wrapper.append(labelNode, input); form.appendChild(wrapper); return input;
        }
        field("Current Password", "currentPassword");
        const password = field("New Password", "newPassword");
        const confirmation = field("Confirm New Password", "confirmPassword");
        const error = document.createElement("div"); error.className = "app-password-error"; error.textContent = "New passwords do not match."; form.appendChild(error);
        actions.remove();
        const formActions = document.createElement("div"); formActions.className = "app-modal-actions";
        const cancel = button("Cancel", "app-modal-cancel");
        const save = button("Save Changes", "app-modal-ok"); save.type = "submit";
        cancel.addEventListener("click", function () { overlay.remove(); });
        function validate() { const mismatch = confirmation.value !== "" && password.value !== confirmation.value; confirmation.setCustomValidity(mismatch ? "Passwords do not match." : ""); error.style.display = mismatch ? "block" : "none"; }
        password.addEventListener("input", validate); confirmation.addEventListener("input", validate);
        formActions.append(cancel, save); form.appendChild(formActions); card.appendChild(form);
        overlay.addEventListener("click", function (event) { if (event.target === overlay) overlay.remove(); });
        document.body.appendChild(overlay); return overlay;
    };

    function showConfirmation(message, onConfirm) {
        ensureStyles();
        const overlay = build("Please Confirm", message, "!");
        const actions = overlay.querySelector(".app-modal-actions");
        const cancel = button("Cancel", "app-modal-cancel");
        const confirm = button("Confirm", "app-modal-confirm");
        cancel.addEventListener("click", function () { overlay.remove(); });
        confirm.addEventListener("click", function () { overlay.remove(); onConfirm(); });
        overlay.addEventListener("click", function (event) { if (event.target === overlay) overlay.remove(); });
        actions.append(cancel, confirm);
        document.body.appendChild(overlay);
    }

    function build(title, message, icon) {
        const overlay = document.createElement("div");
        overlay.className = "app-modal-overlay";
        const card = document.createElement("div"); card.className = "app-modal-card";
        const iconNode = document.createElement("div"); iconNode.className = "app-modal-icon"; iconNode.textContent = icon;
        const heading = document.createElement("h2"); heading.textContent = title;
        const text = document.createElement("p"); text.textContent = message;
        const actions = document.createElement("div"); actions.className = "app-modal-actions";
        card.append(iconNode, heading, text, actions); overlay.appendChild(card); return overlay;
    }
    function button(label, extraClass) { const value = document.createElement("button"); value.type = "button"; value.className = "app-modal-button " + extraClass; value.textContent = label; return value; }

    document.addEventListener("click", function (event) {
        const target = event.target.closest("[data-confirm-message]");
        if (!target) return;
        event.preventDefault();
        showConfirmation(target.getAttribute("data-confirm-message"), function () {
            if (target.tagName === "A") window.location.href = target.href;
            else if (target.form) target.form.submit();
        });
    });

    document.addEventListener("DOMContentLoaded", function () {
        const notification = document.querySelector(".message-success,.message-error,.success-message,.error-message");
        if (!notification || notification.closest(".app-modal-overlay")) return;
        const success = notification.matches(".message-success,.success-message");
        const text = notification.textContent.replace(/\s+/g, " ").trim();
        notification.remove();
        window.showAppNotification(success ? "Success" : "Something Went Wrong", text,
                success ? "success" : "error", 3500);
    });
})();

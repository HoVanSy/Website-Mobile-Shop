<%@ Page Title="" Language="C#" MasterPageFile="~/Khachhang/Main.Master" AutoEventWireup="true" CodeBehind="ThongTinNguoiDung.aspx.cs" Inherits="DAN_FB.ThongTinNguoiDung" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        :root {
            --primary-color: #2563eb;
            --primary-hover: #1d4ed8;
            --secondary-color: #64748b;
            --accent-color: #f59e0b;
            --success-color: #10b981;
            --danger-color: #ef4444;
            --warning-color: #f59e0b;
            --admin-color: #7c3aed;
            --admin-hover: #6d28d9;
            --background-light: #f8fafc;
            --background-white: #ffffff;
            --text-primary: #1e293b;
            --text-secondary: #64748b;
            --text-muted: #94a3b8;
            --border-color: #e2e8f0;
            --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
            --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1);
            --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1);
            --shadow-xl: 0 20px 25px -5px rgb(0 0 0 / 0.1);
            --border-radius: 16px;
            --border-radius-sm: 8px;
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            line-height: 1.6;
            color: var(--text-primary);
            background: var(--background-light);
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 40px 20px;
        }

        /* Login Required Message */
        .login-required {
            text-align: center;
            padding: 80px 20px;
            background: var(--background-white);
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-lg);
            margin: 40px auto;
            max-width: 600px;
        }

        .login-required-icon {
            font-size: 4rem;
            margin-bottom: 24px;
            color: var(--warning-color);
        }

        .login-required-title {
            font-size: clamp(1.5rem, 4vw, 2.25rem);
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 16px;
        }

        .login-required-message {
            font-size: 1.125rem;
            color: var(--text-secondary);
            margin-bottom: 32px;
            line-height: 1.6;
        }

        .login-btn {
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            color: white;
            padding: 16px 32px;
            border: none;
            border-radius: 25px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 12px;
            box-shadow: var(--shadow-md);
        }

        .login-btn:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-xl);
        }

        /* Profile Section */
        .profile-section {
            background: var(--background-white);
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-lg);
            overflow: hidden;
            margin-bottom: 32px;
        }

        .profile-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--accent-color) 100%);
            color: white;
            padding: 40px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .profile-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="dots" width="20" height="20" patternUnits="userSpaceOnUse"><circle cx="10" cy="10" r="1.5" fill="rgba(255,255,255,0.1)"/></pattern></defs><rect width="100" height="100" fill="url(%23dots)"/></svg>');
            opacity: 0.3;
        }

        .profile-avatar {
            position: relative;
            z-index: 2;
            width: 120px;
            height: 120px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            margin: 0 auto 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            border: 4px solid rgba(255, 255, 255, 0.3);
            backdrop-filter: blur(10px);
        }

        .profile-title {
            position: relative;
            z-index: 2;
            font-size: clamp(1.5rem, 4vw, 2rem);
            font-weight: 700;
            margin-bottom: 8px;
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .profile-subtitle {
            position: relative;
            z-index: 2;
            font-size: 1.125rem;
            opacity: 0.9;
        }

        .profile-content {
            padding: 40px;
        }

        .profile-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 32px;
        }

        .info-card {
            background: var(--background-light);
            border-radius: var(--border-radius-sm);
            padding: 24px;
            border: 1px solid var(--border-color);
            transition: var(--transition);
        }

        .info-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-md);
            border-color: var(--primary-color);
        }

        .info-card-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 20px;
        }

        .info-card-icon {
            width: 48px;
            height: 48px;
            background: var(--primary-color);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: white;
        }

        .info-card-title {
            font-size: 1.125rem;
            font-weight: 600;
            color: var(--text-primary);
        }

        .info-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 16px 0;
            border-bottom: 1px solid var(--border-color);
        }

        .info-item:last-child {
            border-bottom: none;
        }

        .info-label {
            font-weight: 500;
            color: var(--text-secondary);
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .info-value {
            font-weight: 600;
            color: var(--text-primary);
            background: var(--background-white);
            padding: 8px 16px;
            border-radius: 20px;
            border: 1px solid var(--border-color);
        }

        .role-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.875rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .role-admin {
            background: linear-gradient(135deg, var(--danger-color), #dc2626);
            color: white;
        }

        .role-user {
            background: linear-gradient(135deg, var(--success-color), #059669);
            color: white;
        }

        .role-manager {
            background: linear-gradient(135deg, var(--accent-color), #d97706);
            color: white;
        }

        /* Action Buttons */
        .action-section {
            background: var(--background-white);
            border-radius: var(--border-radius);
            padding: 32px;
            box-shadow: var(--shadow-lg);
            text-align: center;
        }

        .action-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 24px;
        }

        .action-buttons {
            display: flex;
            justify-content: center;
            gap: 16px;
            flex-wrap: wrap;
        }

        .btn {
            padding: 16px 32px;
            border: none;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            min-width: 160px;
            justify-content: center;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-hover));
            color: white;
            box-shadow: var(--shadow-md);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
        }

        .btn-secondary {
            background: var(--background-light);
            color: var(--text-primary);
            border: 2px solid var(--border-color);
        }

        .btn-secondary:hover {
            background: var(--primary-color);
            color: white;
            border-color: var(--primary-color);
            transform: translateY(-2px);
        }

        .btn-danger {
            background: linear-gradient(135deg, var(--danger-color), #dc2626);
            color: white;
            box-shadow: var(--shadow-md);
        }

        .btn-danger:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
            background: linear-gradient(135deg, #dc2626, #b91c1c);
        }

        .btn-admin {
            background: linear-gradient(135deg, var(--admin-color), var(--admin-hover));
            color: white;
            box-shadow: var(--shadow-md);
            position: relative;
            overflow: hidden;
        }

        .btn-admin::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }

        .btn-admin:hover::before {
            left: 100%;
        }

        .btn-admin:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-xl);
            background: linear-gradient(135deg, var(--admin-hover), #5b21b6);
        }

        /* Admin Panel Special Styling */
        .admin-panel-notice {
            background: linear-gradient(135deg, var(--admin-color), var(--admin-hover));
            border-radius: var(--border-radius);
            padding: 24px;
            margin-bottom: 24px;
            text-align: center;
            color: white;
            box-shadow: var(--shadow-lg);
        }

        .admin-panel-notice h4 {
            font-size: 1.25rem;
            font-weight: 700;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .admin-panel-notice p {
            opacity: 0.9;
            font-size: 1rem;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .container {
                padding: 20px 15px;
            }

            .profile-header {
                padding: 30px 20px;
            }

            .profile-content {
                padding: 24px 20px;
            }

            .profile-grid {
                grid-template-columns: 1fr;
                gap: 20px;
            }

            .action-buttons {
                flex-direction: column;
                align-items: center;
            }

            .btn {
                width: 100%;
                max-width: 300px;
            }

            .info-item {
                flex-direction: column;
                align-items: flex-start;
                gap: 8px;
            }

            .info-value {
                align-self: stretch;
                text-align: center;
            }
        }

        @media (max-width: 480px) {
            .login-required {
                margin: 20px;
                padding: 40px 20px;
            }

            .profile-avatar {
                width: 100px;
                height: 100px;
                font-size: 2.5rem;
            }

            .info-card {
                padding: 20px;
            }

            .action-section {
                padding: 24px 20px;
            }
        }

        /* Animation */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes pulse {
            0%, 100% {
                opacity: 1;
            }
            50% {
                opacity: 0.7;
            }
        }

        .profile-section,
        .action-section {
            animation: fadeInUp 0.6s ease-out;
        }

        .info-card {
            animation: fadeInUp 0.6s ease-out;
        }

        .info-card:nth-child(2) {
            animation-delay: 0.1s;
        }

        .info-card:nth-child(3) {
            animation-delay: 0.2s;
        }

        .btn-admin {
            animation: pulse 2s ease-in-out infinite;
        }
    </style>

    <div class="container">
        <!-- Login Required Message -->
        <div id="tk2" runat="server" class="login-required">
            <div class="login-required-icon">🔒</div>
            <h1 class="login-required-title">Yêu cầu đăng nhập</h1>
            <p class="login-required-message">
                Bạn cần phải đăng nhập để xem thông tin tài khoản của mình.<br>
                Vui lòng đăng nhập để tiếp tục sử dụng dịch vụ.
            </p>
            <a href="Login.aspx" class="login-btn">
                <span>🚀</span>
                Đăng nhập ngay
            </a>
        </div>

        <!-- Admin Panel Notice -->
        <div id="adminNotice" runat="server" class="admin-panel-notice" visible="false">
            <h4>
                <span>⚙️</span>
                Quyền quản trị hệ thống
            </h4>
            <p>Bạn có quyền truy cập vào trang quản trị. Sử dụng nút bên dưới để truy cập bảng điều khiển admin.</p>
        </div>

        <!-- User Profile Section -->
        <div id="txtTTND" runat="server" class="profile-section">
            <div class="profile-header">
                <div class="profile-avatar">
                    👤
                </div>
                <h2 class="profile-title">Thông tin tài khoản</h2>
                <p class="profile-subtitle">Quản lý thông tin cá nhân của bạn</p>
            </div>

            <div class="profile-content">
                <div class="profile-grid">
                    <!-- Account Information -->
                    <div class="info-card">
                        <div class="info-card-header">
                            <div class="info-card-icon">👤</div>
                            <h3 class="info-card-title">Thông tin tài khoản</h3>
                        </div>
                        <div class="info-item" id="tk" runat="server">
                            <span class="info-label">
                                <span>🏷️</span>
                                Tên đăng nhập
                            </span>
                            <span class="info-value">
                                <asp:Label ID="lblUsername" runat="server" />
                            </span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">
                                <span>📅</span>
                                Ngày tham gia
                            </span>
                            <span class="info-value">
                                <!-- Có thể thêm dữ liệu từ database -->
                                <%= DateTime.Now.ToString("dd/MM/yyyy") %>
                            </span>
                        </div>
                    </div>

                    <!-- Role Information -->
                    <div class="info-card">
                        <div class="info-card-header">
                            <div class="info-card-icon">🎭</div>
                            <h3 class="info-card-title">Phân quyền</h3>
                        </div>
                        <div class="info-item" id="tk1" runat="server">
                            <span class="info-label">
                                <span>🔑</span>
                                Vai trò
                            </span>
                            <span class="role-badge role-user">
                                <span>⭐</span>
                                <asp:Label ID="lblRole" runat="server" />
                            </span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">
                                <span>🛡️</span>
                                Trạng thái
                            </span>
                            <span class="info-value" style="color: var(--success-color);">
                                Đã xác thực
                            </span>
                        </div>
                    </div>

                    <!-- Activity Information -->
                    <div class="info-card">
                        <div class="info-card-header">
                            <div class="info-card-icon">📊</div>
                            <h3 class="info-card-title">Hoạt động</h3>
                        </div>
                        <div class="info-item">
                            <span class="info-label">
                                <span>🕐</span>
                                Lần cuối đăng nhập
                            </span>
                            <span class="info-value">
                                <%= DateTime.Now.ToString("HH:mm dd/MM/yyyy") %>
                            </span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">
                                <span>🔢</span>
                                Số lần đăng nhập
                            </span>
                            <span class="info-value">
                                <!-- Có thể thêm counter từ database -->
                                1
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Action Section -->
        <div id="actionSection" runat="server" class="action-section">
            <h3 class="action-title">Quản lý tài khoản</h3>
            <div class="action-buttons">
                <!-- Admin Panel Button - Only visible for Admin role -->
                <a id="adminPanelBtn" runat="server" href="Admin.aspx" class="btn btn-admin" visible="false">
                    <span>⚙️</span>
                    Quản trị hệ thống
                </a>
                
                <a href="EditProfile.aspx" class="btn btn-primary">
                    <span>✏️</span>
                    Chỉnh sửa thông tin
                </a>
                <a href="ChangePassword.aspx" class="btn btn-secondary">
                    <span>🔒</span>
                    Đổi mật khẩu
                </a>
                <asp:Button ID="btnLogout" runat="server" 
                    OnClick="btnLogout_Click" 
                    Text="🚪 Đăng xuất" 
                    CssClass="btn btn-danger"
                    OnClientClick="return confirm('Bạn có chắc chắn muốn đăng xuất?');" />
            </div>
        </div>
    </div>
</asp:Content>
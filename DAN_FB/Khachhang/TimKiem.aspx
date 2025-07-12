<%@ Page Title="" Language="C#" MasterPageFile="~/Khachhang/Main.Master" AutoEventWireup="true" CodeBehind="TimKiem.aspx.cs" Inherits="DAN_FB.TimKiem" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --primary-color: #2563eb;
            --primary-hover: #1d4ed8;
            --secondary-color: #64748b;
            --accent-color: #f59e0b; /* Màu cam nổi bật */
            --success-color: #10b981; /* Màu xanh lá cây cho badge */
            --background-light: #f8fafc; /* Nền xám nhạt cho body */
            --background-white: #ffffff; /* Nền trắng cho card và header */
            --text-primary: #1e293b; /* Màu chữ chính */
            --text-secondary: #64748b; /* Màu chữ phụ/mô tả */
            --border-color: #e2e8f0; /* Màu viền */
            --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
            --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1);
            --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1);
            --shadow-xl: 0 20px 25px -5px rgb(0 0 0 / 0.1);
            --border-radius: 12px; /* Bo góc chung */
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); /* Hiệu ứng chuyển động mượt mà */
        }

        /* Reset và Typography cơ bản */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            line-height: 1.6;
            color: var(--text-primary);
            background: var(--background-light);
            /* Đảm bảo chiều cao tối thiểu cho body để footer (nếu có) luôn ở cuối trang */
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* Container chính */
        .search-container {
            max-width: 1400px; /* Giới hạn chiều rộng tối đa của nội dung.
                                   Nếu bạn muốn nội dung rộng ra hết màn hình,
                                   hãy tăng giá trị này lên hoặc đặt thành `none`.
                                   Ví dụ: `max-width: 1600px;` hoặc `max-width: none;` */
            margin: 0 auto; /* Giữ cho container luôn ở giữa trang */
            padding: 20px;
            flex-grow: 1; /* Cho phép container giãn ra để chiếm hết không gian còn lại */
        }

        /* Search Header (Kết quả tìm kiếm) */
        .search-header {
            background: var(--background-white);
            border-radius: var(--border-radius);
            padding: 24px 32px;
            margin-bottom: 24px;
            box-shadow: var(--shadow-md);
            position: relative;
            overflow: hidden; /* Đảm bảo đường viền màu ở trên không tràn ra */
        }

        /* Đường viền màu nổi bật ở trên cùng của header */
        .search-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--primary-color), var(--accent-color));
        }

        .search-title {
            font-size: clamp(1.5rem, 4vw, 2rem); /* Kích thước chữ linh hoạt */
            font-weight: 800;
            color: var(--text-primary);
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .search-title::before {
            content: '🔍'; /* Icon kính lúp */
            font-size: 1.5em; /* Kích thước lớn hơn chút so với chữ */
            display: inline-block; /* Để căn chỉnh tốt hơn */
            line-height: 1; /* Để icon không làm ảnh hưởng đến chiều cao dòng của text */
        }

        .search-info {
            font-size: 1rem;
            color: var(--text-secondary);
            font-weight: 500;
        }

        /* (search-stats bị ẩn theo yêu cầu, giữ nguyên) */
        .search-stats {
            display: none;
        }

        /* Results Section (Sản phẩm tìm thấy) */
        .results-section {
            background: var(--background-white);
            border-radius: var(--border-radius);
            padding: 24px;
            box-shadow: var(--shadow-md);
            min-height: 400px; /* Đảm bảo không gian đủ khi ít sản phẩm */
        }

        .results-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
            padding-bottom: 12px;
            border-bottom: 2px solid var(--border-color);
            flex-wrap: wrap; /* Cho phép các phần tử xuống dòng trên màn hình nhỏ */
            gap: 16px;
        }

        .results-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .results-title::before {
            content: '📱'; /* Icon điện thoại */
            font-size: 1.2em;
            display: inline-block;
            line-height: 1;
        }

        .sort-controls {
            display: flex;
            gap: 12px;
            align-items: center;
        }

        .sort-label {
            font-weight: 600;
            color: var(--text-secondary);
            font-size: 0.9rem;
        }

        .sort-select {
            padding: 8px 16px;
            border: 2px solid var(--border-color);
            border-radius: 8px;
            background: var(--background-white);
            color: var(--text-primary);
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
            outline: none; /* Xóa outline mặc định */
            -webkit-appearance: none; /* Loại bỏ style mặc định của select trên WebKit browsers */
            -moz-appearance: none; /* Loại bỏ style mặc định của select trên Firefox */
            appearance: none; /* Loại bỏ style mặc định của select */
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 20 20' fill='currentColor'%3E%3Cpath fill-rule='evenodd' d='M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z' clip-rule='evenodd' /%3E%3C/svg%3E"); /* Icon mũi tên xuống */
            background-repeat: no-repeat;
            background-position: right 0.75rem center;
            background-size: 1.25rem;
            padding-right: 2.5rem; /* Tăng padding để icon không bị đè lên text */
        }

        .sort-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1);
        }

        /* DataList Container để cố định Grid */
        .search-results-container {
            width: 100%;
            overflow: hidden; /* Đảm bảo không có scrollbar không mong muốn */
        }

        /* DataList Styles - Cấu trúc lại để dùng CSS Grid */
        .search-datalist {
            width: 100% !important; /* Đảm bảo chiếm toàn bộ chiều rộng */
            display: grid !important; /* Kích hoạt Grid Layout */
            /* Sử dụng auto-fill để tránh phóng to item khi có ít item */
            /* minmax(280px, 1fr) là kích thước tối thiểu 280px, tối đa là 1 phần còn lại */
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)) !important; /* Tạo cột responsive */
            gap: 20px; /* Khoảng cách giữa các item */
            list-style: none; /* Ẩn bullet point */
            padding: 16px 0; /* Padding trên/dưới */
            justify-content: center; /* Căn giữa các cột nếu tổng chiều rộng nhỏ hơn max-width */
        }

        /* Đảm bảo cấu trúc table/td của DataList không phá vỡ Grid */
        /* ĐÂY LÀ PHẦN CỰC KỲ QUAN TRỌNG ĐỂ FIX LỖI 1 CỘT VỚI DataList */
        .search-datalist table {
            width: 100% !important;
            display: contents !important; /* LÀM CHO TABLE TRỞ THÀNH MỘT PHẦN CỦA LUỒNG GRID */
        }

        .search-datalist td {
            display: contents !important; /* LÀM CHO TD TRỞ THÀNH MỘT PHẦN CỦA LUỒNG GRID */
        }

        /* Product Card */
        .search-product-link {
            text-decoration: none;
            color: inherit;
            display: block; /* Quan trọng để link bao bọc toàn bộ card */
            transition: var(--transition);
            width: 100%; /* Chiếm toàn bộ chiều rộng của cột grid */
            height: 100%; /* Chiếm toàn bộ chiều cao của cột grid */
        }

        .search-product-link:hover {
            transform: translateY(-8px); /* Nâng card lên khi hover */
            z-index: 5; /* Đảm bảo card hover không bị che bởi card khác */
        }

        .search-product-card {
            background: var(--background-white);
            border: 1px solid var(--border-color);
            border-radius: var(--border-radius);
            overflow: hidden;
            box-shadow: var(--shadow-md);
            transition: var(--transition);
            position: relative;
            height: 420px; /* Chiều cao cố định cho card */
            display: flex;
            flex-direction: column;
            max-width: 320px; /* Giới hạn kích thước tối đa của từng card */
            width: 100%; /* Đảm bảo card chiếm toàn bộ không gian được cấp */
            margin: 0 auto; /* Căn giữa card trong cột Grid */
        }

        .search-product-card:hover {
            box-shadow: var(--shadow-xl); /* Bóng đổ lớn hơn khi hover */
            border-color: var(--primary-color);
        }

        /* Hiệu ứng đường viền trên khi hover */
        .search-product-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--primary-color), var(--accent-color));
            transform: scaleX(0); /* Ban đầu ẩn */
            transform-origin: left; /* Hiệu ứng từ trái sang phải */
            transition: transform 0.3s ease;
        }

        .search-product-card:hover::before {
            transform: scaleX(1); /* Hiện ra khi hover */
        }

        /* Product Image */
        .search-product-image-container {
            position: relative;
            overflow: hidden;
            background: var(--background-light);
            padding: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 220px; /* Chiều cao cố định cho vùng ảnh */
            flex-shrink: 0; /* Ngăn không cho vùng ảnh bị co lại */
        }

        .search-product-image {
            width: 100%;
            height: 100%;
            max-height: 190px; /* Giới hạn chiều cao tối đa của ảnh trong container */
            object-fit: contain; /* Giữ tỷ lệ khung hình, không bị cắt */
            transition: var(--transition);
            border-radius: 8px; /* Bo góc ảnh */
        }

        .search-product-card:hover .search-product-image {
            transform: scale(1.05); /* Phóng to ảnh nhẹ khi hover */
        }

        .search-product-badge {
            position: absolute;
            top: 12px;
            right: 12px;
            background: var(--success-color); /* Màu xanh lá cây */
            color: white;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            z-index: 1;
            /* Thêm shadow nhẹ */
            box-shadow: var(--shadow-sm);
        }

        /* Product Info */
        .search-product-info {
            padding: 20px;
            flex: 1; /* Cho phép phần info giãn ra chiếm hết không gian còn lại */
            display: flex;
            flex-direction: column;
            justify-content: space-between; /* Đẩy các phần tử ra xa nhau */
        }

        .search-product-name {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 8px;
            line-height: 1.4;
            white-space: nowrap; /* Ngăn không cho chữ xuống dòng */
            overflow: hidden; /* Ẩn phần chữ tràn */
            text-overflow: ellipsis; /* Hiển thị dấu ba chấm nếu tràn */
            height: 1.5em; /* Đảm bảo chỉ hiển thị 1 dòng */
        }

        .search-product-description {
            font-size: 0.9rem;
            color: var(--text-secondary);
            margin-bottom: 16px;
            line-height: 1.5;
            display: -webkit-box; /* Kích hoạt webkit line-clamp */
            -webkit-line-clamp: 2; /* Giới hạn 2 dòng */
            -webkit-box-orient: vertical;
            overflow: hidden;
            flex: 1; /* Cho phép giãn ra */
        }

        .search-product-price {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 16px; /* Khoảng cách với nút */
        }

        .search-product-actions {
            margin-top: auto; /* Đẩy nút xuống dưới cùng */
        }

        .search-btn-primary {
            width: 100%;
            background: var(--primary-color);
            color: white;
            border: none;
            padding: 12px 16px;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            font-size: 0.95rem;
            box-shadow: var(--shadow-sm); /* Thêm bóng đổ cho nút */
        }

        .search-btn-primary:hover {
            background: var(--primary-hover);
            transform: translateY(-1px);
            box-shadow: var(--shadow-md); /* Tăng bóng đổ khi hover */
        }

        /* No Results State */
        .no-results {
            text-align: center;
            padding: 80px 20px;
            color: var(--text-secondary);
        }

        .no-results-icon {
            font-size: 4rem;
            margin-bottom: 24px;
            opacity: 0.6;
        }

        .no-results h3 {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 12px;
        }

        .no-results p {
            font-size: 1rem;
            line-height: 1.6;
            max-width: 500px;
            margin: 0 auto 24px;
        }

        .no-results a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 600;
            padding: 12px 24px;
            border: 2px solid var(--primary-color);
            border-radius: 25px;
            display: inline-block;
            transition: var(--transition);
        }

        .no-results a:hover {
            background: var(--primary-color);
            color: white;
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
        }

        /* Loading State */
        .loading {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 200px; /* Đảm bảo đủ không gian cho spinner */
            color: var(--text-secondary);
            font-size: 1.1rem;
        }

        .loading::after {
            content: '';
            width: 40px;
            height: 40px;
            border: 3px solid var(--border-color);
            border-top: 3px solid var(--primary-color);
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin-left: 12px;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Animation cho Product Card */
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

        .search-product-card {
            animation: fadeInUp 0.6s ease-out forwards; /* Thêm forwards để giữ trạng thái cuối animation */
            opacity: 0; /* Ban đầu ẩn để animation bắt đầu từ 0 */
        }

        /* Thêm delay cho các card để tạo hiệu ứng staggered */
        /* Sử dụng nth-child(n) và biến CSS để tạo delay dựa trên vị trí */
        .search-datalist .search-product-link .search-product-card {
            animation-delay: calc(var(--item-index, 0) * 0.1s); /* Delay 0.1s cho mỗi item */
        }

        /* Responsive Design */
        @media (max-width: 1200px) {
            .search-datalist {
                grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)) !important;
                gap: 20px;
            }

            .search-product-card {
                height: 400px;
                max-width: 300px;
            }

            .search-product-image-container {
                height: 200px;
            }

            .search-product-image {
                max-height: 170px;
            }
        }

        @media (max-width: 1024px) {
            .search-datalist {
                grid-template-columns: repeat(auto-fill, minmax(240px, 1fr)) !important;
            }

            .search-product-card {
                max-width: 280px;
            }

            .results-header {
                flex-direction: column;
                align-items: flex-start;
            }
        }

        @media (max-width: 768px) {
            .search-container {
                padding: 15px;
            }

            .search-header,
            .results-section {
                padding: 20px;
            }

            .search-datalist {
                grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)) !important;
                gap: 16px;
            }

            .search-product-card {
                height: 380px;
                max-width: 260px;
            }

            .search-product-image-container {
                height: 180px;
            }

            .search-product-image {
                max-height: 150px;
            }

            /* Ẩn search-stats (đã ẩn) */

            .sort-controls {
                width: 100%;
                justify-content: space-between;
            }
        }

        @media (max-width: 480px) {
            .search-container {
                padding: 10px;
            }

            .search-datalist {
                grid-template-columns: 1fr !important; /* Chỉ 1 cột trên màn hình rất nhỏ */
                justify-content: center;
            }

            .search-product-card {
                height: 360px;
                max-width: 100%; /* Cho phép card giãn hết chiều rộng */
                margin: 0 auto; /* Căn giữa card */
            }

            .search-product-image-container {
                height: 160px;
                padding: 12px;
            }

            .search-product-image {
                max-height: 130px;
            }

            .search-header,
            .results-section {
                padding: 16px;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="search-container">
        <div class="search-header">
            <h1 class="search-title">Kết quả tìm kiếm</h1>
            <div class="search-info">
                <asp:Label ID="lblSearchInfo" runat="server" Text='Kết quả tìm kiếm cho: "<%= Request.QueryString["keyword"] %>"'></asp:Label>
            </div>
        </div>

        <div class="results-section">
            <div class="results-header">
                <h2 class="results-title">Sản phẩm tìm thấy</h2>
                <div class="sort-controls">
                    <span class="sort-label">Sắp xếp:</span>
                    <select class="sort-select">
                        <option value="relevant">Liên quan nhất</option>
                        <option value="price-asc">Giá tăng dần</option>
                        <option value="price-desc">Giá giảm dần</option>
                        <option value="name">Tên A-Z</option>
                        <option value="newest">Mới nhất</option>
                    </select>
                </div>
            </div>

            <div class="search-results-container">
                <asp:DataList ID="dtlSanPham" runat="server"
                    RepeatDirection="Horizontal"
                    RepeatLayout="Flow"
                    CssClass="search-datalist">
                    <ItemTemplate>
                        <%-- Thêm style cho animation-delay dựa trên index của item --%>
                        <a href='ViewSP.aspx?ID=<%# Eval("MaSP") %>' class="search-product-link"
                           style="--item-index: <%# Container.ItemIndex %>;">
                            <div class="search-product-card">
                                <div class="search-product-image-container">
                                    <img src='<%# Eval("HinhAnh") %>' alt='<%# Eval("TenSP") %>' class="search-product-image" loading="lazy" />
                                    <div class="search-product-badge">
                                        <%-- Bạn có thể thêm logic ở đây để hiển thị badge phù hợp --%>
                                        <%-- Ví dụ: <%# Eval("IsNew") != null && (bool)Eval("IsNew") ? "MỚI" : "" %> --%>
                                        Tìm thấy
                                    </div>
                                </div>
                                <div class="search-product-info">
                                    <h3 class="search-product-name"><%# Eval("TenSP") %></h3>
                                    <p class="search-product-description">Mô tả ngắn gọn về sản phẩm: <%# Eval("TenSP") %></p>
                                    <div class="search-product-price"><%# String.Format("{0:N0}₫", Eval("Gia")) %></div>
                                    <div class="search-product-actions">
                                        <button class="search-btn-primary" type="button">Xem chi tiết</button>
                                    </div>
                                </div>
                            </div>
                        </a>
                    </ItemTemplate>
                </asp:DataList>
            </div>

            <asp:Panel ID="pnlNoResults" runat="server" CssClass="no-results" Visible="false">
                <div class="no-results-icon">🤔</div>
                <h3>Không tìm thấy sản phẩm nào</h3>
                <p>Rất tiếc, chúng tôi không tìm thấy sản phẩm nào phù hợp với từ khóa của bạn. Hãy thử lại với từ khóa khác hoặc kiểm tra chính tả.</p>
                <a href="Default.aspx">Quay về trang chủ</a>
            </asp:Panel>
            <%-- <div class="loading" style="display: none;">Đang tải sản phẩm...</div> --%>
        </div>
    </div>
</asp:Content>
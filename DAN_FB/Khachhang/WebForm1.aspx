<%@ Page Title="" Language="C#" MasterPageFile="~/Khachhang/Main.Master" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="DAN_FB.WebForm1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        :root {
            /* Màu sắc - giữ nguyên tông lạnh, dịu mắt */
            --primary-color: #537FE7; /* Xanh dương trung tính */
            --primary-hover: #456BBF; /* Xanh dương đậm hơn khi hover */
            --secondary-color: #8C98A4; /* Xám xanh dịu */
            --accent-color: #FFD54F; /* Vàng nhạt (màu kem) */
            --success-color: #81C784; /* Xanh lá cây nhạt cho thành công */
            --background-light: #F0F4F8; /* Nền xám xanh cực nhạt, gần như trắng */
            --background-white: #FFFFFF; /* Trắng tinh khiết */
            --text-primary: #37474F; /* Xám đậm, dễ đọc */
            --text-secondary: #78909C; /* Xám xanh cho chữ phụ */
            --border-color: #C0D0DE; /* Màu viền rất nhẹ */
            --shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.05); /* Bóng nhẹ hơn */
            --shadow-md: 0 4px 8px rgba(0, 0, 0, 0.09); /* Bóng nhẹ hơn */
            --shadow-lg: 0 6px 15px rgba(0, 0, 0, 0.12); /* Bóng nhẹ hơn */
            --shadow-xl: 0 12px 30px rgba(0, 0, 0, 0.14); /* Bóng nhẹ hơn */
            --border-radius: 10px; /* Bo góc lớn hơn một chút */
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-size: 0.9em; /* Tăng font-size tổng thể lên so với 0.8em trước */
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            line-height: 1.5; /* Điều chỉnh line-height phù hợp hơn */
            color: var(--text-primary);
            background: var(--background-light);
        }

        /* Container lớn hơn một chút */
        .container {
            max-width: 1200px; /* Tăng từ 980px lên, khoảng 85% của 1400px gốc */
            margin: 0 auto;
            padding: 0 20px; /* Tăng padding */
        }

        /* Hero Section */
        .hero-section {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--accent-color) 100%); /* Điều chỉnh gradient, vàng gần hơn một chút */
            color: white;
            padding: 60px 0; /* Tăng padding */
            margin-bottom: 32px; /* Tăng margin */
            border-radius: var(--border-radius);
            position: relative;
            overflow: hidden;
        }

        .hero-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grid" width="10" height="10" patternUnits="userSpaceOnUse"><path d="M 10 0 L 0 0 0 10" fill="none" stroke="rgba(255,255,255,0.1)" stroke-width="0.5"/></pattern></defs><rect width="100" height="100" fill="url(%23grid)"/></svg>'); /* Tăng nhẹ opacity lưới */
            opacity: 0.4; 
        }

        .hero-content {
            position: relative;
            z-index: 2;
            text-align: center;
            max-width: 800px; /* Tăng max-width */
            margin: 0 auto;
            padding: 0 20px; /* Tăng padding */
        }

        .hero-title {
            font-size: clamp(2rem, 4vw, 3.5rem); /* Tăng font-size */
            font-weight: 800;
            margin-bottom: 16px; /* Tăng margin */
            text-shadow: 0 2px 4px rgba(0,0,0,0.15); /* Bóng rõ hơn */
        }

        .hero-subtitle {
            font-size: clamp(0.9rem, 1.8vw, 1.1rem); /* Tăng font-size */
            opacity: 0.9; 
            margin-bottom: 30px; /* Tăng margin */
        }

        .hero-stats {
            display: flex;
            justify-content: center;
            gap: 40px; /* Tăng gap */
            margin-top: 30px; /* Tăng margin */
            flex-wrap: wrap;
        }

        .hero-stat {
            text-align: center;
            min-width: 100px; /* Tăng min-width */
        }

        .hero-stat-number {
            font-size: clamp(1.8rem, 3.5vw, 2.8rem); /* Tăng font-size */
            font-weight: 700;
            display: block;
        }

        .hero-stat-label {
            font-size: 0.8rem; /* Tăng font-size */
            opacity: 0.8;
            text-transform: uppercase;
            letter-spacing: 0.05em; /* Tăng nhẹ letter-spacing */
        }

        /* Main Layout */
        .main-layout {
            display: grid;
            grid-template-columns: 280px 1fr; /* Tăng kích thước sidebar */
            gap: 32px; /* Tăng gap */
            margin-top: 20px; /* Tăng margin */
            max-width: none;
        }

        /* Sidebar */
        .sidebar {
            background: var(--background-white);
            border-radius: var(--border-radius);
            padding: 24px; /* Tăng padding */
            box-shadow: var(--shadow-md);
            height: fit-content;
            position: sticky;
            top: 20px; /* Tăng top */
        }

        .sidebar-title {
            font-size: 1.25rem; /* Tăng font-size */
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 20px; /* Tăng margin */
            display: flex;
            align-items: center;
            gap: 8px; /* Tăng gap */
        }

        .sidebar-title::before {
            content: '📱';
            font-size: 1.5rem; /* Tăng font-size icon */
        }

        .category-list {
            width: 100%;
            border: 1px solid var(--border-color);
            border-radius: var(--border-radius);
            background: var(--background-light);
            padding: 12px; /* Tăng padding */
            font-size: 0.9rem; /* Tăng font-size */
            outline: none;
            transition: var(--transition);
            min-height: 240px; /* Tăng min-height */
        }

        .category-list:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(83, 127, 231, 0.15); /* Tăng nhẹ shadow khi focus */
        }

        .category-list option {
            padding: 10px; /* Tăng padding */
            margin: 4px 0; /* Tăng margin */
            border-radius: 6px; /* Tăng border-radius */
            background: white;
            border: 1px solid var(--border-color);
        }

        .category-list option:hover,
        .category-list option:selected {
            background: var(--primary-color);
            color: white;
        }

        /* Product Section */
        .product-section {
            background: var(--background-white);
            border-radius: var(--border-radius);
            padding: 32px 32px 60px 32px; /* Tăng padding */
            box-shadow: var(--shadow-md);
            min-width: 0;
        }

        /* Header section */
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 32px; /* Tăng margin */
            padding-bottom: 16px; /* Tăng padding */
            border-bottom: 1px solid var(--border-color);
            flex-wrap: wrap;
            gap: 16px; /* Tăng gap */
        }

        .section-title {
            font-size: clamp(1.25rem, 2.8vw, 1.75rem); /* Tăng font-size */
            font-weight: 700;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            gap: 12px; /* Tăng gap */
        }

        .section-title::before {
            content: '✨';
            font-size: 1.5rem; /* Tăng font-size icon */
        }

        .view-all-btn {
            background: var(--primary-color);
            color: white;
            padding: 10px 20px; /* Tăng padding */
            border: none;
            border-radius: 20px; /* Tăng border-radius */
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px; /* Tăng gap */
            white-space: nowrap;
            font-size: 0.9rem; /* Tăng font-size */
        }

        .view-all-btn:hover {
            background: var(--primary-hover);
            transform: translateY(-2px); /* Tăng hiệu ứng translate */
            box-shadow: var(--shadow-lg);
        }

        /* DataList Container */
        .product-grid-container {
            width: 100%;
            overflow: hidden;
        }

        /* DataList Styles */
        .product-datalist {
            width: 100% !important;
            display: grid !important;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)) !important; /* Tăng minmax */
            gap: 24px; /* Tăng gap */
            list-style: none;
            padding: 16px 0; /* Tăng padding */
        }

        .product-datalist table {
            width: 100% !important;
            display: contents !important;
        }

        .product-datalist td {
            display: contents !important;
        }

        /* Product Card */
        .product-link {
            text-decoration: none;
            color: inherit;
            display: block;
            transition: var(--transition);
            width: 100%;
            height: 100%;
        }

        .product-link:hover {
            transform: translateY(-6px); /* Tăng hiệu ứng translate */
            z-index: 10;
        }

        .product-card {
            background: var(--background-white);
            border: 1px solid var(--border-color);
            border-radius: var(--border-radius);
            overflow: hidden;
            box-shadow: var(--shadow-md);
            transition: var(--transition);
            position: relative;
            height: 380px; /* Tăng chiều cao cố định */
            display: flex;
            flex-direction: column;
            max-width: 100%;
        }

        .product-card:hover {
            box-shadow: var(--shadow-xl);
            border-color: var(--primary-color);
        }

        .product-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px; /* Tăng độ dày border */
            background: linear-gradient(90deg, var(--primary-color), var(--accent-color));
            transform: scaleX(0);
            transition: transform 0.3s ease;
        }

        .product-card:hover::before {
            transform: scaleX(1);
        }

        /* Product Image Container */
        .product-image-container {
            position: relative;
            overflow: hidden;
            background: var(--background-light);
            padding: 16px; /* Tăng padding */
            display: flex;
            align-items: center;
            justify-content: center;
            height: 180px; /* Tăng chiều cao cố định */
            flex-shrink: 0;
        }

        .product-image {
            width: 100%;
            height: 100%;
            max-height: 150px; /* Tăng max-height */
            object-fit: contain;
            transition: var(--transition);
            border-radius: 6px; /* Tăng border-radius */
        }

        .product-card:hover .product-image {
            transform: scale(1.05); /* Tăng hiệu ứng scale */
        }

        /* Product Badge */
        .product-badge {
            position: absolute;
            top: 12px; /* Tăng top */
            right: 12px; /* Tăng right */
            background: var(--accent-color);
            color: var(--text-primary);
            padding: 4px 10px; /* Tăng padding */
            border-radius: 16px; /* Tăng border-radius */
            font-size: 0.75rem; /* Tăng font-size */
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            z-index: 1;
        }

        /* Product Info */
        .product-info {
            padding: 16px; /* Tăng padding */
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        /* Product Name */
        .product-name {
            font-size: 1rem; /* Tăng font-size */
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 8px; /* Tăng margin */
            line-height: 1.4;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            height: 1.4em;
        }

        /* Product Description */
        .product-description {
            font-size: 0.85rem; /* Tăng font-size */
            color: var(--text-secondary);
            margin-bottom: 12px; /* Tăng margin */
            line-height: 1.5;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            flex: 1;
        }

        /* Product Price */
        .product-price {
            font-size: 1.2rem; /* Tăng font-size */
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 16px; /* Tăng margin */
        }

        /* Product Actions */
        .product-actions {
            margin-top: auto;
        }

        /* Button Primary */
        .btn-primary {
            width: 100%;
            background: var(--primary-color);
            color: white;
            border: none;
            padding: 10px 16px; /* Tăng padding */
            border-radius: 8px; /* Tăng border-radius */
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            font-size: 0.9rem; /* Tăng font-size */
        }

        .btn-primary:hover {
            background: var(--primary-hover);
            transform: translateY(-2px);
            box-shadow: var(--shadow-sm);
        }

        /* Loading State */
        .loading {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 150px; /* Tăng chiều cao */
            color: var(--text-secondary);
        }

        .loading::after {
            content: '';
            width: 36px; /* Tăng kích thước spinner */
            height: 36px; /* Tăng kích thước spinner */
            border: 3px solid var(--border-color); /* Tăng độ dày border */
            border-top: 3px solid var(--primary-color); /* Tăng độ dày border */
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin-left: 10px; /* Tăng margin */
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Responsive Design - Điều chỉnh lại theo kích thước mới */
        @media (max-width: 1400px) { 
            .container {
                max-width: 1100px;
            }
            .main-layout {
                grid-template-columns: 250px 1fr;
                gap: 28px;
            }
            .product-datalist {
                grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)) !important;
                gap: 20px;
            }
            .product-card {
                height: 350px;
            }
            .product-image-container {
                height: 160px;
            }
            .product-image {
                max-height: 130px;
            }
        }

        @media (max-width: 1200px) { 
            .container {
                max-width: 960px;
            }
            .main-layout {
                grid-template-columns: 220px 1fr;
                gap: 24px;
            }
            .product-datalist {
                grid-template-columns: repeat(auto-fill, minmax(180px, 1fr)) !important;
                gap: 18px;
            }
            .product-card {
                height: 320px;
            }
            .product-image-container {
                height: 140px;
            }
            .product-image {
                max-height: 110px;
            }
        }

        @media (max-width: 1024px) { 
            .container {
                padding: 0 16px;
            }
            .main-layout {
                grid-template-columns: 1fr;
                gap: 20px;
            }
            .sidebar {
                position: static;
                order: 2;
            }
            .product-section {
                order: 1;
            }
            .product-datalist {
                grid-template-columns: repeat(auto-fill, minmax(160px, 1fr)) !important;
            }
            .hero-section {
                padding: 40px 0;
                margin-bottom: 24px;
            }
            .hero-title {
                font-size: clamp(1.8rem, 4.5vw, 2.8rem);
            }
            .hero-subtitle {
                font-size: clamp(0.85rem, 1.6vw, 1rem);
            }
            .sidebar-title {
                font-size: 1.1rem;
            }
        }

        @media (max-width: 768px) { 
            .container {
                padding: 0 12px;
            }
            .hero-section {
                padding: 30px 0;
                margin-bottom: 20px;
            }
            .hero-stats {
                gap: 20px;
            }
            .sidebar,
            .product-section {
                padding: 16px;
            }
            .product-datalist {
                grid-template-columns: repeat(auto-fill, minmax(140px, 1fr)) !important;
                gap: 16px;
            }
            .section-header {
                flex-direction: column;
                align-items: flex-start;
            }
            .product-card {
                height: 280px;
            }
            .product-image-container {
                height: 120px;
            }
            .product-image {
                max-height: 90px;
            }
            .product-name {
                font-size: 0.9rem;
            }
            .product-price {
                font-size: 1.1rem;
            }
            .btn-primary {
                font-size: 0.85rem;
                padding: 8px 12px;
            }
        }

        @media (max-width: 480px) { 
            .container {
                padding: 0 8px;
            }
            .product-datalist {
                grid-template-columns: 1fr !important;
            }
            .hero-stats {
                flex-direction: column;
                gap: 12px;
            }
            .category-list {
                min-height: 180px;
            }
            .product-section {
                padding: 12px;
            }
            .product-card {
                height: 250px;
            }
            .product-image-container {
                height: 100px;
                padding: 10px;
            }
            .product-image {
                max-height: 80px;
            }
            .hero-title {
                font-size: clamp(1.6rem, 5vw, 2.4rem);
            }
            .hero-subtitle {
                font-size: clamp(0.8rem, 2vw, 0.9rem);
            }
        }

        /* Animation */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(24px); 
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .product-card {
            animation: fadeInUp 0.6s ease-out;
        }

        .product-card:nth-child(even) {
            animation-delay: 0.08s;
        }

        .product-card:nth-child(3n) {
            animation-delay: 0.16s; 
        }
    </style>

    <div class="container">
        <div class="hero-section">
            <div class="hero-content">
                <h1 class="hero-title">Mobile Shop</h1>
                <p class="hero-subtitle">Điện thoại chính hãng - Giá tốt nhất thị trường - Bảo hành toàn quốc</p>
                <div class="hero-stats">
                    <div class="hero-stat">
                        <span class="hero-stat-number">10K+</span>
                        <span class="hero-stat-label">Khách hàng</span>
                    </div>
                    <div class="hero-stat">
                        <span class="hero-stat-number">500+</span>
                        <span class="hero-stat-label">Sản phẩm</span>
                    </div>
                    <div class="hero-stat">
                        <span class="hero-stat-number">99%</span>
                        <span class="hero-stat-label">Hài lòng</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="main-layout">
            <div class="sidebar">
                <h3 class="sidebar-title">Danh mục sản phẩm</h3>
                <asp:ListBox ID="ListBox1" runat="server" 
                    DataSourceID="SqlDataSource1" 
                    DataTextField="TenLoai" 
                    DataValueField="MaLoai" 
                    CssClass="category-list"
                    AutoPostBack="True" 
                    OnSelectedIndexChanged="ListBox1_SelectedIndexChanged">
                </asp:ListBox>
                <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:MyConnection %>" 
                    ProviderName="<%$ ConnectionStrings:MyConnection.ProviderName %>" 
                    SelectCommand="SELECT * FROM [LoaiSanPham]">
                </asp:SqlDataSource>
            </div>

            <div class="product-section">
                <div class="section-header">
                    <h2 class="section-title">Sản phẩm nổi bật</h2>
                    <a href="#" class="view-all-btn">
                        Xem tất cả
                        <span>→</span>
                    </a>
                </div>

                <div class="product-grid-container">
                    <asp:DataList ID="dtlSanPham" runat="server" 
                        RepeatDirection="Horizontal" 
                        RepeatLayout="Flow"
                        CssClass="product-datalist">
                        <ItemTemplate>
                            <a href='ViewSP.aspx?ID=<%# Eval("MaSP") %>' class="product-link"> 
                                <div class="product-card">
                                    <div class="product-image-container">
                                        <img src='<%# Eval("HinhAnh") %>' alt='<%# Eval("TenSP") %>' class="product-image" />
                                        <div class="product-badge">Hot</div>
                                    </div>
                                    <div class="product-info">
                                        <p class="product-name"><%# Eval("TenSP") %></p>
                                        <div class="product-price"><%# String.Format("{0:N0} VNĐ", Eval("Gia")) %></div>
                                        <div class="product-actions">
                                            <button class="btn-primary" type="button" onclick="BtnXemngay_Click">Xem ngay</button>
                                        </div>
                                    </div>
                                </div>
                            </a>
                        </ItemTemplate>
                    </asp:DataList>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
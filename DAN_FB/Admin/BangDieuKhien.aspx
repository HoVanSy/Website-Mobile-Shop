<%@ Page Title="Bảng Điều Khiển - Trang Quản Trị" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="BangDieuKhien.aspx.cs" Inherits="DAN_FB.Admin.BangDieuKhien" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

  
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container">
        <div class="page-header">
            <div>
                <h2>Bảng Điều Khiển</h2>
                <p>Tổng quan dữ liệu và hiệu suất hoạt động của hệ thống.</p>
            </div>
        </div>

        <div class="stats-grid">
            <!-- Thẻ 1: Tổng sản phẩm -->
            <div class="stat-card">
                <div class="stat-icon"><i class="fas fa-box-open"></i></div>
                <div class="stat-info">
                    <div class="stat-label">Tổng sản phẩm</div>
                    <div class="stat-number"><asp:Label ID="lblTongSanPham" runat="server" Text="0"></asp:Label></div>
                </div>
            </div>
            <!-- Thẻ 2: Tổng đơn hàng -->
            <div class="stat-card">
                <div class="stat-icon"><i class="fas fa-shopping-cart"></i></div>
                <div class="stat-info">
                    <div class="stat-label">Tổng đơn hàng</div>
                    <div class="stat-number"><asp:Label ID="lblTongDonHang" runat="server" Text="0"></asp:Label></div>
                </div>
            </div>
            <!-- Thẻ 3: Tổng khách hàng -->
            <div class="stat-card">
                <div class="stat-icon"><i class="fas fa-users"></i></div>
                <div class="stat-info">
                    <div class="stat-label">Tổng khách hàng</div>
                    <div class="stat-number"><asp:Label ID="lblTongKhachHang" runat="server" Text="0"></asp:Label></div>
                </div>
            </div>
            <!-- Thẻ 4: Tổng doanh thu -->
            <div class="stat-card">
                <div class="stat-icon"><i class="fas fa-wallet"></i></div>
                <div class="stat-info">
                    <div class="stat-label">Tổng doanh thu</div>
                    <div class="stat-number"><asp:Label ID="lblTongDoanhThu" runat="server" Text="0 ₫"></asp:Label></div>
                </div>
            </div>
        </div>

        <div class="chart-grid">
            <!-- Các canvas cho biểu đồ -->
            <div class="chart-section">
                <div class="chart-header">
                    <i class="fas fa-chart-line chart-icon" style="color: var(--color-blue);"></i>
                    <h3>Doanh Thu 6 Tháng Gần Nhất</h3>
                </div>
                <div class="chart-canvas-container"><canvas id="revenueChart"></canvas></div>
            </div>
            <div class="chart-section">
                <div class="chart-header">
                    <i class="fas fa-chart-bar chart-icon" style="color: var(--color-green);"></i>
                    <h3>Top 5 Sản Phẩm Bán Chạy</h3>
                </div>
                <div class="chart-canvas-container"><canvas id="topProductsChart"></canvas></div>
            </div>
            <div class="chart-section">
                <div class="chart-header">
                    <i class="fas fa-pie-chart chart-icon" style="color: var(--color-amber);"></i>
                    <h3>Tỷ Lệ Trạng Thái Đơn Hàng</h3>
                </div>
                <div class="chart-canvas-container" style="max-width: 280px; margin: auto; min-height: 280px;"><canvas id="orderStatusChart"></canvas></div>
            </div>
            <div class="chart-section">
                <div class="chart-header">
                    <i class="fas fa-user-plus chart-icon" style="color: var(--color-violet);"></i>
                    <h3>Khách Hàng Mới Theo Tháng</h3>
                </div>
                <div class="chart-canvas-container"><canvas id="newCustomersChart"></canvas></div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        document.addEventListener('DOMContentLoaded', function () {

            // =================================================================================
            // HƯỚNG DẪN QUAN TRỌNG: NẠP DỮ LIỆU CHO BIỂU ĐỒ TỪ C#
            // =================================================================================
            // Để biểu đồ hiển thị, bạn BẮT BUỘC phải truyền dữ liệu từ C# code-behind.
            // Trong file BangDieuKhien.aspx.cs, tại sự kiện Page_Load, hãy thêm đoạn code sau:
            //
            // // 1. Lấy dữ liệu từ DB cho các biểu đồ (ví dụ)
            // var revenueData = new { labels = new[] {"T1", "T2"}, data = new[] {100, 200} };
            // var topProductsData = new { labels = new[] {"iPhone", "Samsung"}, data = new[] {50, 80} };
            // var orderStatusData = new { labels = new[] {"Hoàn thành", "Hủy"}, data = new[] {120, 10} };
            // var newCustomersData = new { labels = new[] {"T1", "T2"}, data = new[] {15, 25} };
            //
            // // 2. Tạo đối tượng tổng hợp
            // var chartData = new {
            //     revenue = revenueData,
            //     topProducts = topProductsData,
            //     orderStatus = orderStatusData,
            //     newCustomers = newCustomersData
            // };
            //
            // // 3. Serialize thành JSON và đăng ký script
            // string jsonChartData = new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(chartData);
            // Page.ClientScript.RegisterStartupScript(this.GetType(), "ChartDataScript", $"const serverChartData = {jsonChartData};", true);
            // =================================================================================

            const chartData = typeof serverChartData !== 'undefined' ? serverChartData : {};

            // === CÁC HÀM TIỆN ÍCH ===
            const formatCurrency = (value) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(value);
            const formatNumber = (value) => new Intl.NumberFormat('vi-VN').format(value);

            // === HÀM HIỂN THỊ THÔNG BÁO KHI KHÔNG CÓ DỮ LIỆU ===
            function displayNoDataMessage(canvasId, message = "Không có dữ liệu để hiển thị.") {
                const canvas = document.getElementById(canvasId);
                if (canvas) {
                    const ctx = canvas.getContext('2d');
                    const dpr = window.devicePixelRatio || 1;
                    canvas.width = canvas.offsetWidth * dpr;
                    canvas.height = canvas.offsetHeight * dpr;
                    ctx.scale(dpr, dpr);
                    ctx.clearRect(0, 0, canvas.width, canvas.height);
                    ctx.save();
                    ctx.textAlign = 'center';
                    ctx.textBaseline = 'middle';
                    ctx.font = "16px 'Be Vietnam Pro'";
                    ctx.fillStyle = 'var(--text-secondary)';
                    ctx.fillText(message, canvas.offsetWidth / 2, canvas.offsetHeight / 2);
                    ctx.restore();
                }
            }

            // === HÀM HIỆU ỨNG ĐẾM SỐ ===
            //function animateNumbers() {
            //    const numberElements = [
            //        //{ id: '<%= lblTongSanPham.ClientID %>', isCurrency: false },
                    ////{ id: '<%= lblTongDonHang.ClientID %>', isCurrency: false },
                    ////{ id: '<%= lblTongKhachHang.ClientID %>', isCurrency: false },
            //      //  { id: '<%= lblTongDoanhThu.ClientID %>', isCurrency: true }
            //    ];

            //    numberElements.forEach(item => {
            //        const el = document.getElementById(item.id);
            //        if (!el) return;
            //        const endValue = parseInt((el.textContent || '0').replace(/\D/g, '')) || 0;
            //        if (endValue === 0) {
            //            el.textContent = item.isCurrency ? formatCurrency(0) : '0';
            //            return;
            //        }
            //        const duration = 1500;
            //        let startTime = null;
            //        function animation(currentTime) {
            //            if (startTime === null) startTime = currentTime;
            //            const elapsed = currentTime - startTime;
            //            const progress = Math.min(elapsed / duration, 1);
            //            const currentVal = Math.floor(progress * endValue);
            //            el.textContent = item.isCurrency ? formatCurrency(currentVal) : formatNumber(currentVal);
            //            if (progress < 1) requestAnimationFrame(animation);
            //            else el.textContent = item.isCurrency ? formatCurrency(endValue) : formatNumber(endValue);
            //        }
            //        requestAnimationFrame(animation);
            //    });
            //}

            // === HÀM VẼ BIỂU ĐỒ ===
            function renderAllCharts() {
                Chart.defaults.font.family = "'Be Vietnam Pro', sans-serif";
                Chart.defaults.color = '#6B7280';

                const chartsToRender = [
                    { id: 'revenueChart', type: 'line', data: chartData.revenue, options: { scales: { y: { ticks: { callback: (v) => formatNumber(v / 1000) + 'K' } } }, plugins: { legend: { display: false }, tooltip: { callbacks: { label: (c) => formatCurrency(c.parsed.y) } } } }, config: { borderColor: 'var(--color-blue)', backgroundColor: 'rgba(59, 130, 246, 0.1)', fill: true, tension: 0.4 } },
                    { id: 'topProductsChart', type: 'bar', data: chartData.topProducts, options: { indexAxis: 'y', plugins: { legend: { display: false } }, scales: { x: { beginAtZero: true } } }, config: { backgroundColor: 'rgba(16, 185, 129, 0.7)', borderColor: 'var(--color-green)', borderWidth: 1, borderRadius: 4 } },
                    { id: 'orderStatusChart', type: 'doughnut', data: chartData.orderStatus, options: { plugins: { legend: { position: 'bottom' } } }, config: { backgroundColor: ['var(--color-green)', 'var(--color-amber)', 'var(--color-red)', 'var(--color-cyan)'], hoverOffset: 4 } },
                    { id: 'newCustomersChart', type: 'bar', data: chartData.newCustomers, options: { plugins: { legend: { display: false } }, scales: { y: { beginAtZero: true } } }, config: { backgroundColor: 'rgba(139, 92, 246, 0.7)', borderColor: 'var(--color-violet)', borderWidth: 1, borderRadius: 4 } }
                ];

                chartsToRender.forEach(chartInfo => {
                    const canvas = document.getElementById(chartInfo.id);
                    if (canvas && chartInfo.data && chartInfo.data.labels && chartInfo.data.labels.length > 0) {
                        new Chart(canvas, {
                            type: chartInfo.type,
                            data: {
                                labels: chartInfo.data.labels,
                                datasets: [{
                                    label: chartInfo.data.label || 'Dataset',
                                    data: chartInfo.data.data,
                                    ...chartInfo.config
                                }]
                            },
                            options: {
                                responsive: true,
                                maintainAspectRatio: false,
                                ...chartInfo.options
                            }
                        });
                    } else if (canvas) {
                        displayNoDataMessage(chartInfo.id);
                    }
                });
            }

            // === KHỞI CHẠY ===
            setTimeout(() => {
                //animateNumbers();
                renderAllCharts();
            }, 100);
        });
    </script>
</asp:Content>

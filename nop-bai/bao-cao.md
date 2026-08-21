# Báo Cáo Lab Day 21 - CI/CD cho AI Systems

| | |
|---|---|
| Họ và tên | Đỗ Văn Linh |
| MSSV | 2A202601190 |
| Lớp / Khóa | K4 |
| Repo GitHub | https://github.com/DoVanLinh12/K4-Track2-Day21-2A202601190-DoVanLinh |
| Ngày nộp | 21/08/2026 |

---

## 1. Bộ Siêu Tham Số Đã Chọn và Lý Do

| Lần chạy | n_estimators | learning_rate | max_depth | f1_score | accuracy |
|---|---|---|---|---|---|
| 1 | 100 | 0.1 | 3 | 0.7109 | 0.8780 |
| 2 | 50 | 0.05 | 2 | 0.6051 | 0.8460 |
| 3 | 200 | 0.1 | 5 | 0.7149 | 0.8740 |

**Bộ siêu tham số đã chọn:** `n_estimators=200`, `learning_rate=0.1`, `max_depth=5`.

**Lý do:** Lần 3 có F1 cao nhất (0.7149), nên được chọn dù accuracy 0.8740 thấp hơn mức 0.8780 của lần 1. Kết quả cho thấy accuracy cao nhất không đồng nghĩa nhận diện lớp thu nhập cao tốt nhất. Lần 2 có ít cây, learning rate thấp và cây nông nên thiếu khớp, F1 chỉ 0.6051. Tăng số cây và độ sâu giúp F1 cao hơn nhưng làm huấn luyện lâu và mô hình phức tạp hơn.

---

## 2. Vì Sao Ngưỡng Chất Lượng Đặt Trên F1 Chứ Không Phải Accuracy

Chỉ 24,8% mẫu thuộc lớp thu nhập trên 50K nên dữ liệu bị mất cân bằng. Mô hình luôn dự đoán “thu nhập thấp” vẫn đạt accuracy 0.752 nhưng F1 lớp dương bằng 0 vì không phát hiện người thu nhập cao. F1 kết hợp precision và recall, nên chỉ cao khi mô hình vừa hạn chế dự đoán dương sai, vừa tìm được đủ trường hợp dương thật. Lab dùng `f1_score(y_eval, preds)` mặc định cho lớp dương để quality gate đo trực tiếp nhóm cần quan tâm. Không dùng weighted F1 vì lớp đa số có thể kéo kết quả lên; macro F1 cũng không phản ánh riêng lớp thu nhập cao.

---

## 3. Khó Khăn Gặp Phải và Cách Giải Quyết

| Khó khăn | Nguyên nhân | Cách giải quyết |
|---|---|---|
| MLflow không khởi động | Setuptools 84 đã loại `pkg_resources` mà MLflow 2.13 còn sử dụng | Ghim `setuptools==80.9.0` trong requirements |
| Không tạo được S3 bucket | IAM user thiếu quyền `s3:CreateBucket` | Thêm policy S3 giới hạn cho bucket của lab |
| DVC báo `Permission denied` | Cache pytest được tạo với ACL khác trên Windows | Bỏ qua `.pytest_cache/`, xóa cache tạm rồi chạy lại DVC |

---

## 4. So Sánh Bước 2 và Bước 3 (bắt buộc, 2 - 3 câu)

| | f1_score | accuracy |
|---|---|---|
| Bước 2 (chỉ `train_batch1`) | 0.7149 | 0.8740 |
| Bước 3 (thêm `train_batch2`) | 0.7354 | 0.8820 |

**Nhận xét:** Sau khi tăng dữ liệu huấn luyện từ 22.361 lên 44.722 mẫu, F1 tăng 0.0205 và accuracy tăng 0.0080. Mức tăng vừa phải là hợp lý vì batch mới được lấy ngẫu nhiên từ cùng nguồn và có phân phối tương tự batch đầu; giá trị chính của Bước 3 là toàn bộ quá trình huấn luyện, kiểm tra và triển khai đã tự động chạy từ một commit dữ liệu.

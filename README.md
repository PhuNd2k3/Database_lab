# ERD_convert
<p>ERD convert</br>
Bước 1: Chuyển tất cả tập thực thể sang mô hình quan hệ</br>
- Thuộc tính thường chuyển sang bổ sung kiểu dữ liệu</br>
- Thuộc tính khóa chuyển sang phải gạch chân nét liền</br>
- Thuộc tính kết hợp chuyển sang phải chú thích phần kết hợp</br>
- Thuộc tính đa trị thì lập một bảng riêng có khóa ngoại trỏ đến bảng chính</br>
Bước 2: Đối với mối kết hợp nhiều - nhiều</br>
- Lập ra một bảng riêng có tên của mối kết hợp</br>
- Bổ sung một cặp khóa chính gồm khóa chính của hai bảng</br>
- Đồng thời mỗi khóa chính cũng là khóa ngoại trỏ về hai bảng</br>
Bước 3: Đối với mối kết hợp một - nhiều</br>
- Bổ sung khóa ngoại vào bảng một</br>
- Trỏ khóa ngoại của bảng một về bảng nhiều</br>
Bước 4: Đối với mối kết hợp một - một</br>
- Bổ sung khóa ngoại vào một hoặc cả hai bảng</br>
- Trỏ khóa ngoại của bảng này đến bảng kia</br>
Chú ý: Khóa ngoại gạch chân nét chấm và cùng kiểu dữ liệu với khóa chính trỏ đến
</p>

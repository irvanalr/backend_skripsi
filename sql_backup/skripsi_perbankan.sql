-- Membuat database skripsi_perbankan
CREATE DATABASE skripsi_perbankan;

-- Menggunakan database skripsi_perbankan
USE skripsi_perbankan;

-- Membuat tabel token
CREATE TABLE token (
    id INT AUTO_INCREMENT PRIMARY KEY,
    token_value VARCHAR(255) NOT NULL UNIQUE,                                             
    tanggal_di_buat DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    tanggal_kadaluarsa DATETIME NOT NULL,
    status ENUM('active', 'revoked') NOT NULL DEFAULT 'active'
);

-- Membuat tabel informasi_user
CREATE TABLE informasi_user (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    token_value VARCHAR(255) NOT NULL DEFAULT 'skripsiPerbankan',
    nama VARCHAR(255) NOT NULL,
    no_hp VARCHAR(255) NOT NULL,
    jenis_kelamin ENUM('Laki-laki', 'Perempuan'),
    tanggal_lahir DATE NOT NULL,
    registrasi DATETIME NOT NULL,
    nik VARCHAR(255) UNIQUE NOT NULL,
    nama_ibu_kandung VARCHAR(255) NOT NULL,
    registrasi_status ENUM('pending', 'verified', 'registered', 'expired') DEFAULT 'pending',
    FOREIGN KEY (token_value) REFERENCES token(token_value) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Membuat tabel alamat_user
CREATE TABLE alamat_user (
    id INT AUTO_INCREMENT PRIMARY KEY,
    kode_pos VARCHAR(10) NOT NULL,
    email VARCHAR(255) NOT NULL,
    alamat VARCHAR(255) NOT NULL,
    kota VARCHAR(255) NOT NULL,
    FOREIGN KEY (email) REFERENCES informasi_user(email) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Membuat tabel informasi_admin
CREATE TABLE informasi_admin (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    token_value VARCHAR(255) NOT NULL DEFAULT 'skripsiPerbankan',
    nama VARCHAR(255) NOT NULL,
    no_hp VARCHAR(255) NOT NULL,
    jenis_kelamin ENUM('Laki-laki', 'Perempuan'),
    tanggal_lahir DATE NOT NULL,
    registrasi DATE NOT NULL,
    nik VARCHAR(255) UNIQUE NOT NULL,
    FOREIGN KEY (token_value) REFERENCES token(token_value) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Membuat tabel alamat_admin
CREATE TABLE alamat_admin (
    id INT AUTO_INCREMENT PRIMARY KEY,
    kode_pos VARCHAR(10) NOT NULL,
    email VARCHAR(255) NOT NULL,
    alamat VARCHAR(255) NOT NULL,
    kota VARCHAR(255) NOT NULL,
    FOREIGN KEY (email) REFERENCES informasi_admin(email) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Membuat table otp
CREATE TABLE otp (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL,                    
    otp_code CHAR(6) NOT NULL,                   
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,     
    status ENUM('active', 'used', 'expired') NOT NULL DEFAULT 'active',
    FOREIGN KEY (email) REFERENCES informasi_user(email) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Membuat tabel otentikasi_user
CREATE TABLE otentikasi_user (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    token_value VARCHAR(255) NOT NULL DEFAULT 'skripsiPerbankan',
    nama_pengguna VARCHAR(255) UNIQUE DEFAULT NULL,
    kata_sandi VARCHAR(255) DEFAULT NULL,
    pin VARCHAR(6) DEFAULT NULL,
    account_status ENUM('active', 'revoked') DEFAULT 'active',
    FOREIGN KEY (token_value) REFERENCES token(token_value) ON DELETE CASCADE ON UPDATE CASCADE ,
    FOREIGN KEY (email) REFERENCES informasi_user(email) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Membuat tabel otentikasi_admin
CREATE TABLE otentikasi_admin (
    id INT AUTO_INCREMENT PRIMARY KEY,
    token_value VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    nama_pengguna VARCHAR(255) UNIQUE,
    kata_sandi VARCHAR(255) DEFAULT NULL,
    account_status ENUM('active', 'revoked') DEFAULT 'active',
    FOREIGN KEY (token_value) REFERENCES token(token_value) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (email) REFERENCES informasi_admin(email) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Membuat table user_activity_login
CREATE TABLE user_activity_login (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nama_pengguna VARCHAR(255),
  total_login INT DEFAULT 0,
  last_login DATETIME,
  FOREIGN KEY (nama_pengguna) REFERENCES otentikasi_user(nama_pengguna) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Membuat table user_activity_logout
CREATE TABLE user_activity_logout (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nama_pengguna VARCHAR(255),
  total_logout INT DEFAULT 0,
  last_logout DATETIME,
  FOREIGN KEY (nama_pengguna) REFERENCES otentikasi_user(nama_pengguna) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Membuat table user_activity_failed_login
CREATE TABLE user_activity_failed_login (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nama_pengguna VARCHAR(255),
  total_failed_login INT DEFAULT 0,
  last_failed_login DATETIME,
  FOREIGN KEY (nama_pengguna) REFERENCES otentikasi_user(nama_pengguna) ON DELETE CASCADE ON UPDATE CASCADE 
);

-- Membuat table user_activity_change_password
CREATE TABLE user_activity_change_password (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nama_pengguna VARCHAR(255),
  total_change_password INT DEFAULT 0,
  last_change_password DATETIME,
  FOREIGN KEY (nama_pengguna) REFERENCES otentikasi_user(nama_pengguna) ON DELETE CASCADE ON UPDATE CASCADE  
);

-- Membuat table admin_activity_login
CREATE TABLE admin_activity_login (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nama_pengguna VARCHAR(255),
  total_login INT DEFAULT 0,
  last_login DATETIME,
  FOREIGN KEY (nama_pengguna) REFERENCES otentikasi_admin(nama_pengguna) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Membuat table admin_activity_logout
CREATE TABLE admin_activity_logout (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nama_pengguna VARCHAR(255),
  total_logout INT DEFAULT 0,
  last_logout DATETIME,
  FOREIGN KEY (nama_pengguna) REFERENCES otentikasi_admin(nama_pengguna) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Membuat table admin_activity_failed_login
CREATE TABLE admin_activity_failed_login (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nama_pengguna VARCHAR(255),
  total_failed_login INT DEFAULT 0,
  last_failed_login DATETIME,
  FOREIGN KEY (nama_pengguna) REFERENCES otentikasi_admin(nama_pengguna) ON DELETE CASCADE ON UPDATE CASCADE 
);

-- Membuat tabel perusahaan
CREATE TABLE perusahaan (
    id INT AUTO_INCREMENT PRIMARY KEY,
    kode_perusahaan VARCHAR(20) UNIQUE,
    perusahaan VARCHAR(255) NOT NULL,
    email_admin VARCHAR(255) NOT NULL,
    FOREIGN KEY (email_admin) REFERENCES informasi_admin(email) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Membuat tabel informasi_perusahaan
CREATE TABLE informasi_perusahaan (
    id INT AUTO_INCREMENT PRIMARY KEY,
    kode_perusahaan VARCHAR(20) NOT NULL,
    alamat TEXT NOT NULL,
    telepon VARCHAR(20),
    website VARCHAR(255),
    deskripsi TEXT,
    FOREIGN KEY (kode_perusahaan) REFERENCES perusahaan(kode_perusahaan) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Membuat tabel cabang
CREATE TABLE cabang (
    id INT AUTO_INCREMENT PRIMARY KEY,
    kode_cabang VARCHAR(20) UNIQUE,
    kode_perusahaan VARCHAR(20) NOT NULL,
    cabang VARCHAR(255) NOT NULL,
    email_admin VARCHAR(255) NOT NULL,
    FOREIGN KEY (kode_perusahaan) REFERENCES perusahaan(kode_perusahaan) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (email_admin) REFERENCES informasi_admin(email) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Membuat table informasi_cabang
CREATE TABLE informasi_cabang (
    id INT AUTO_INCREMENT PRIMARY KEY,
    kode_cabang VARCHAR(20) NOT NULL,
    alamat TEXT NOT NULL,
    telepon VARCHAR(20),
    manager_cabang VARCHAR(255),
    FOREIGN KEY (kode_cabang) REFERENCES cabang(kode_cabang) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Membuat tabel produk_simpanan
CREATE TABLE produk_simpanan (
    id INT AUTO_INCREMENT PRIMARY KEY,
    kode_simpanan VARCHAR(20) UNIQUE,
    email VARCHAR(255) NOT NULL,
    kode_cabang VARCHAR(20) NOT NULL,
    nama_produk_simpanan VARCHAR(255) NOT NULL,
    FOREIGN KEY (kode_cabang) REFERENCES cabang(kode_cabang) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (email) REFERENCES informasi_user(email) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Membuat tabel simpanan
CREATE TABLE simpanan (
    id INT AUTO_INCREMENT PRIMARY KEY,
    kode_simpanan VARCHAR(20) UNIQUE,
    skema_produk VARCHAR(50) NOT NULL,
    tanggal_di_buat DATETIME NOT NULL,
    saldo_simpanan DECIMAL(15, 2) NOT NULL,
    FOREIGN KEY (kode_simpanan) REFERENCES produk_simpanan(kode_simpanan) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Membuat tabel transaksi
CREATE TABLE transaksi_simpanan (
    id INT AUTO_INCREMENT PRIMARY KEY,
    kode_transaksi VARCHAR(20) UNIQUE,
    kode_simpanan VARCHAR(20) NOT NULL,
    tanggal_transaksi DATE NOT NULL,
    deskripsi_transaksi VARCHAR(255) NOT NULL,
    arah_transaksi ENUM('1', '0') NOT NULL,
    nilai_transaksi DECIMAL(15, 2) NOT NULL,
    saldo_akhir_transaksi DECIMAL(15, 2) NOT NULL,
    FOREIGN KEY (kode_simpanan) REFERENCES produk_simpanan(kode_simpanan) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Membuat tabel produk_deposito
CREATE TABLE produk_deposito (
    id INT AUTO_INCREMENT PRIMARY KEY,
    kode_deposito VARCHAR(20) UNIQUE,
    kode_cabang VARCHAR(20) NOT NULL,
    nama_produk_deposito VARCHAR(255) NOT NULL,
    FOREIGN KEY (kode_cabang) REFERENCES cabang(kode_cabang) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Membuat tabel deposito
CREATE TABLE deposito (
    id INT AUTO_INCREMENT PRIMARY KEY,
    kode_bilyet_deposito VARCHAR(20) UNIQUE,
    kode_deposito VARCHAR(20) NOT NULL,
    tanggal_mulai_deposito DATE NOT NULL,
    tanggal_akhir_deposito DATE NOT NULL,
    aro_deposito INT NOT NULL,
    saldo_deposito DECIMAL(15, 2) NOT NULL,
    FOREIGN KEY (kode_deposito) REFERENCES produk_deposito(kode_deposito) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Membuat tabel produk_pembiayaan
CREATE TABLE produk_pembiayaan (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Kode_pembiayaan VARCHAR(20) UNIQUE,
    kode_cabang VARCHAR(20) NOT NULL,
    nama_produk_pembiayaan VARCHAR(255) NOT NULL,
    FOREIGN KEY (kode_cabang) REFERENCES cabang(kode_cabang) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Membuat tabel pembiayaan
CREATE TABLE pembiayaan (
    id INT AUTO_INCREMENT PRIMARY KEY,
    kontrak VARCHAR(20) UNIQUE,
    kode_pembiayaan VARCHAR(20) NOT NULL,
    tanggal_kontrak_pembiayaan DATE NOT NULL,
    pokok_pembiayaan DECIMAL(15, 2) NOT NULL,
    margin_pembiayaan DECIMAL(15, 2) NOT NULL,
    bunga_pembiayaan INT NOT NULL,
    jangka_waktu_pembiayaan INT NOT NULL,
    tipe_jangka_waktu_pembiayaan INT NOT NULL,
    nama_jangka_waktu_pembiayaan VARCHAR(50) NOT NULL,
    FOREIGN KEY (kode_pembiayaan) REFERENCES produk_pembiayaan(kode_pembiayaan) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Memasukan data ke table token
INSERT INTO token (token_value, tanggal_kadaluarsa, tanggal_di_buat, status) VALUES
('skripsiPerbankan', '2025-02-28 12:00:00', '2024-08-20 10:00:00', 'active');

-- Menambahkan data dummy ke tabel informasi_user
INSERT INTO informasi_admin (email, token_value, nama, no_hp, jenis_kelamin, tanggal_lahir, registrasi, nik) 
VALUES
('irvan.rasyid@mail.com', 'skripsiPerbankan', 'Irvan Al Rasyid', '081234567890', 'Laki-laki', '1999-05-15', '2025-01-08', '1234567890123456'),
('dina.sari@mail.com', 'skripsiPerbankan', 'Dina Sari', '089876543210', 'Perempuan', '1998-10-22', '2025-01-08', '6543210987654321');

-- Menambahkan data dummy ke tabel alamat_user
INSERT INTO alamat_admin (kode_pos, email, alamat, kota)
VALUES
('12345', 'irvan.rasyid@mail.com', 'Jl. Raya No. 15', 'Jakarta'),
('67890', 'dina.sari@mail.com', 'Jl. Merdeka No. 30', 'Bandung');

-- Menambahkan data ke tabel otentikasi
INSERT INTO otentikasi_admin (nama_pengguna, token_value, email, kata_sandi) VALUES
('59bed01d56df678d6e74299b938f6e19:keSE65y88HmDgIOPjmQlLWMbUts1vsrbhQKkKaFi2U+h0Tr/B6xqJcw0FOemktHH', 'skripsiPerbankan', 'irvan.rasyid@mail.com', '3a121aa1e249c862b2723d96c77fd491:jQ/+ELQXD2Nn2m32ZNvp+h4RjiS46jazP5LAOB2+NCH9nVVxEdut1q/xxtkwmBio'),
('8f7717d6809e5244de53b32ea5cde588:E6dnhypl9wqERl+EpfJygmpWvgR9u66OaY69Z0eWCsm/pRT0dIdJJWQNuyPFjY9T', 'skripsiPerbankan', 'dina.sari@mail.com', '166495cb03373908f61a8f32ebc9297e:PIFHjrl/e79LqKevt3stfBzUt61F37zNzuwQPuro3dxoyCRnkafjO+eRwwnnXdEZ');

-- Memasukan data ke tabel perusahaan
INSERT INTO perusahaan (kode_perusahaan, perusahaan, email_admin)
VALUES
('P001', 'PT Jakarta Selatan Mandiri', 'irvan.rasyid@mail.com'),
('P002', 'PT Tangerang Selatan Sejahtera', 'dina.sari@mail.com');

-- Memasukan data ke tabel informasi_perusahaan
INSERT INTO informasi_perusahaan (kode_perusahaan, alamat, telepon, website, deskripsi)
VALUES
('P001', 'Jl. Sudirman No. 10, Jakarta Selatan', '021-12345678', 'www.jakartaselatan.com', 'Perusahaan yang bergerak di bidang teknologi di Jakarta Selatan.'),
('P002', 'Jl. Serpong Raya No. 20, Tangerang Selatan', '021-87654321', 'www.tangerangselatan.com', 'Perusahaan yang bergerak di bidang logistik di Tangerang Selatan.');

-- Memasukan data ke tabel cabang
INSERT INTO cabang (kode_cabang, kode_perusahaan, cabang, email_admin)
VALUES
('C001', 'P001', 'Cabang Blok M', 'irvan.rasyid@mail.com'),
('C002', 'P002', 'Cabang Serpong', 'dina.sari@mail.com');

-- Memasukan data ke tabel informasi_cabang
INSERT INTO informasi_cabang (kode_cabang, alamat, telepon, manager_cabang)
VALUES
('C001', 'Jl. Melawai No. 15, Blok M, Jakarta Selatan', '021-23456789', 'Budi Santoso'),
('C002', 'Jl. Alam Sutera No. 5, Serpong, Tangerang Selatan', '021-98765432', 'Siti Nurhaliza');
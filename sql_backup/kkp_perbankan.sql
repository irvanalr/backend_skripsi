-- Membuat tabel informasi_user
CREATE TABLE informasi_user (
    email VARCHAR(255) PRIMARY KEY,
    nama VARCHAR(255),
    no_hp VARCHAR(20),
    jenis_kelamin VARCHAR(10),
    tanggal_lahir DATE,
    registrasi DATE,
    kode_akun VARCHAR(10)
);

-- Membuat tabel alamat_user
CREATE TABLE alamat_user (
    kode_pos VARCHAR(10) PRIMARY KEY,
    email VARCHAR(255),
    alamat VARCHAR(255),
    kota VARCHAR(100),
    FOREIGN KEY (email) REFERENCES informasi_user(email)
);

-- Membuat tabel token
CREATE TABLE token (
    token_value VARCHAR(255) NOT NULL,
    email VARCHAR(255),                                
    tanggal_kadaluarsa DATETIME NOT NULL,             
    tanggal_di_buat DATETIME DEFAULT CURRENT_TIMESTAMP, 
    status ENUM('active', 'inactive', 'revoked') DEFAULT 'active', 
    FOREIGN KEY (email) REFERENCES informasi_user(email)
);

-- Membuat tabel otentikasi
CREATE TABLE otentikasi (
    nama_pengguna VARCHAR(255) PRIMARY KEY,
    email VARCHAR(255),
    kata_sandi VARCHAR(255),
    pin VARCHAR(6),
    aktivasi ENUM('active', 'inactive', 'revoked') DEFAULT 'active',
    FOREIGN KEY (email) REFERENCES informasi_user(email)
);

-- Membuat tabel perusahaan
CREATE TABLE perusahaan (
    kode_perusahaan VARCHAR(20) PRIMARY KEY,
    email VARCHAR(255),
    perusahaan VARCHAR(255),
    FOREIGN KEY (email) REFERENCES informasi_user(email)
);

CREATE TABLE cabang (
    kode_cabang VARCHAR(20) PRIMARY KEY,
    kode_perusahaan VARCHAR(20),
    cabang VARCHAR(255),
    FOREIGN KEY (kode_perusahaan) REFERENCES perusahaan(kode_perusahaan)
);

-- Membuat tabel produk_simpanan
CREATE TABLE produk_simpanan (
    kode_simpanan VARCHAR(20) PRIMARY KEY,
    kode_cabang VARCHAR(20),
    nama_produk_simpanan VARCHAR(255),
    FOREIGN KEY (kode_cabang) REFERENCES cabang(kode_cabang)
);

-- Membuat tabel simpanan
CREATE TABLE simpanan (
    id_simpanan INT AUTO_INCREMENT PRIMARY KEY,
    kode_simpanan VARCHAR(20),
    skema_produk VARCHAR(50),
    tanggal_di_buat DATETIME,
    saldo_simpanan DECIMAL(15, 2),
    FOREIGN KEY (kode_simpanan) REFERENCES produk_simpanan(kode_simpanan)
);

-- Membuat tabel transaksi
CREATE TABLE transaksi (
    kode_transaksi VARCHAR(20) PRIMARY KEY,
    kode_simpanan VARCHAR(20),
    tanggal_transaksi DATE,
    deskripsi_transaksi VARCHAR(255),
    arah_transaksi ENUM('1', '0'),
    nilai_transaksi DECIMAL(15, 2),
    saldo_akhir_transaksi DECIMAL(15, 2),
    FOREIGN KEY (kode_simpanan) REFERENCES produk_simpanan(kode_simpanan)
);

-- Membuat tabel produk_deposito
CREATE TABLE produk_deposito (
    kode_deposito VARCHAR(20) PRIMARY KEY,
    kode_cabang VARCHAR(20),
    nama_produk_deposito VARCHAR(255),
    FOREIGN KEY (kode_cabang) REFERENCES cabang(kode_cabang)
);

-- Membuat tabel deposito
CREATE TABLE deposito (
    kode_bilyet_deposito VARCHAR(20) PRIMARY KEY,
    kode_deposito VARCHAR(20),
    tanggal_mulai_deposito DATE,
    tanggal_akhir_deposito DATE,
    aro_deposito INT,
    saldo_deposito DECIMAL(15, 2),
    FOREIGN KEY (kode_deposito) REFERENCES produk_deposito(kode_deposito)
);

-- Membuat tabel produk_pembiayaan
CREATE TABLE produk_pembiayaan (
    Kode_pembiayaan VARCHAR(20) PRIMARY KEY,
    kode_cabang VARCHAR(20),
    nama_produk_pembiayaan VARCHAR(255),
    FOREIGN KEY (kode_cabang) REFERENCES cabang(kode_cabang)
);

-- Membuat tabel pembiayaan
CREATE TABLE pembiayaan (
    kontrak VARCHAR(20) PRIMARY KEY,
    kode_pembiayaan VARCHAR(20),
    tanggal_kontrak_pembiayaan DATE,
    pokok_pembiayaan DECIMAL(15, 2),
    margin_pembiayaan DECIMAL(15, 2),
    bunga_pembiayaan INT,
    jangka_waktu_pembiayaan INT,
    tipe_jangka_waktu_pembiayaan INT,
    nama_jangka_waktu_pembiayaan VARCHAR(50),
    FOREIGN KEY (kode_pembiayaan) REFERENCES produk_pembiayaan(kode_pembiayaan)
);

-- Menambahkan data ke tabel informasi_user
INSERT INTO informasi_user (email, nama, no_hp, jenis_kelamin, tanggal_lahir, registrasi, kode_akun) VALUES
('irvan@gmail.com', 'Irvan Al Rasyid', '081234567890', 'Laki-laki', '2000-10-15', '2023-08-20', '10000213');

-- Menambahkan data ke tabel alamat_user
INSERT INTO alamat_user (kode_pos, email, alamat, kota) VALUES 
('12345', 'irvan@gmail.com', 'Jl. Raya No. 1', 'Jakarta');

-- Menambahkan data ke tabel token
INSERT INTO token (token_value, email, tanggal_kadaluarsa, tanggal_di_buat, status) VALUES
('kkpPerbankan', 'irvan@gmail.com', '2024-09-01 12:00:00', '2024-08-20 10:00:00', 'active');

-- Menambahkan data ke tabel otentikasi
INSERT INTO otentikasi (nama_pengguna, email, kata_sandi, pin, aktivasi) VALUES
('irvan', 'irvan@gmail.com', 'irvan123', '123456', 'active');

-- Menambahkan data ke tabel perusahaan
INSERT INTO perusahaan (kode_perusahaan, email, perusahaan) VALUES
('998', 'irvan@gmail.com', 'KOPERASI SYARIAH DEMO');

-- Menambahkan data ke tabel cabang
INSERT INTO cabang (kode_cabang, kode_perusahaan, cabang) VALUES
('00', '998', 'PUSAT');

-- Menambahkan data ke tabel produk_simpanan
INSERT INTO produk_simpanan (kode_simpanan, kode_cabang, nama_produk_simpanan) VALUES 
('116 04 5063', '00', 'TABUNGAN SIMPATI'),
('SP 16 05 00099', '00', 'SIMPANAN POKOK'),
('SW 16 05 00099', '00', 'SIMPANAN WAJIB');

-- Menambahkan data ke tabel simpanan
INSERT INTO simpanan (kode_simpanan, skema_produk, tanggal_di_buat, saldo_simpanan) VALUES
('116 04 5063', 'WADIAH', '2020-05-08', 4209596.00),
('SP 16 05 00099', 'POKOK WAJIB', '2020-06-08', 100000.00),
('SW 16 05 00099', 'POKOK WAJIB', '2020-07-08', 420000.00);

-- Menambahkan data ke tabel transaksi untuk kodeSimpanan '116 04 5063'
INSERT INTO transaksi (kode_transaksi, kode_simpanan, tanggal_transaksi, deskripsi_transaksi, arah_transaksi, nilai_transaksi, saldo_akhir_transaksi) VALUES
('TRANS001', '116 04 5063', '2024-08-01', 'Transfer - Irvan Al Rasyid (116 04 5063)', '1', 500000.00, 4709596.00),
('TRANS002', '116 04 5063', '2024-08-01', 'Penarikan - Irvan Al Rasyid (116 04 5063)', '0', 100000.00, 4609596.00),
('TRANS003', '116 04 5063', '2024-08-01', 'Transfer - Irvan Al Rasyid (116 04 5063)', '1', 200000.00, 4409596.00),
('TRANS004', '116 04 5063', '2024-08-01', 'Penarikan - Irvan Al Rasyid (116 04 5063)', '0', 150000.00, 4259596.00),
('TRANS005', '116 04 5063', '2024-08-01', 'Transfer - Irvan Al Rasyid (116 04 5063)', '1', 300000.00, 3959596.00),
('TRANS006', '116 04 5063', '2024-08-02', 'Penarikan - Irvan Al Rasyid (116 04 5063)', '0', 50000.00, 3909596.00),
('TRANS007', '116 04 5063', '2024-08-02', 'Transfer - Irvan Al Rasyid (116 04 5063)', '1', 250000.00, 3659596.00),
('TRANS008', '116 04 5063', '2024-08-02', 'Penarikan - Irvan Al Rasyid (116 04 5063)', '0', 200000.00, 3459596.00),
('TRANS009', '116 04 5063', '2024-08-02', 'Transfer - Irvan Al Rasyid (116 04 5063)', '1', 100000.00, 3359596.00),
('TRANS010', '116 04 5063', '2024-08-02', 'Penarikan - Irvan Al Rasyid (116 04 5063)', '0', 100000.00, 3259596.00),
('TRANS011', '116 04 5063', '2024-08-03', 'Transfer - Irvan Al Rasyid (116 04 5063)', '1', 150000.00, 3109596.00),
('TRANS012', '116 04 5063', '2024-08-03', 'Penarikan - Irvan Al Rasyid (116 04 5063)', '0', 80000.00, 3029596.00),
('TRANS013', '116 04 5063', '2024-08-03', 'Transfer - Irvan Al Rasyid (116 04 5063)', '1', 200000.00, 2829596.00),
('TRANS014', '116 04 5063', '2024-08-03', 'Penarikan - Irvan Al Rasyid (116 04 5063)', '0', 120000.00, 2709596.00),
('TRANS015', '116 04 5063', '2024-08-03', 'Transfer - Irvan Al Rasyid (116 04 5063)', '1', 300000.00, 2409596.00),
('TRANS016', '116 04 5063', '2024-08-04', 'Penarikan - Irvan Al Rasyid (116 04 5063)', '0', 150000.00, 2259596.00),
('TRANS017', '116 04 5063', '2024-08-04', 'Transfer - Irvan Al Rasyid (116 04 5063)', '1', 400000.00, 1859596.00),
('TRANS018', '116 04 5063', '2024-08-04', 'Penarikan - Irvan Al Rasyid (116 04 5063)', '0', 250000.00, 1609596.00),
('TRANS019', '116 04 5063', '2024-08-04', 'Transfer - Irvan Al Rasyid (116 04 5063)', '1', 50000.00, 1559596.00),
('TRANS020', '116 04 5063', '2024-08-04', 'Penarikan - Irvan Al Rasyid (116 04 5063)', '0', 100000.00, 1459596.00);

-- Menambahkan data ke tabel transaksi untuk kodeSimpanan 'SP 16 05 00099'
INSERT INTO transaksi (kode_transaksi, kode_simpanan, tanggal_transaksi, deskripsi_transaksi, arah_transaksi, nilai_transaksi, saldo_akhir_transaksi) VALUES
('TRANS021', 'SP 16 05 00099', '2024-08-01', 'Transfer - Irvan Al Rasyid (SP 16 05 00099)', '1', 50000.00, 150000.00),
('TRANS022', 'SP 16 05 00099', '2024-08-01', 'Penarikan - Irvan Al Rasyid (SP 16 05 00099)', '0', 10000.00, 140000.00),
('TRANS023', 'SP 16 05 00099', '2024-08-01', 'Transfer - Irvan Al Rasyid (SP 16 05 00099)', '1', 20000.00, 120000.00),
('TRANS024', 'SP 16 05 00099', '2024-08-01', 'Penarikan - Irvan Al Rasyid (SP 16 05 00099)', '0', 5000.00, 115000.00),
('TRANS025', 'SP 16 05 00099', '2024-08-01', 'Transfer - Irvan Al Rasyid (SP 16 05 00099)', '1', 15000.00, 100000.00),
('TRANS026', 'SP 16 05 00099', '2024-08-02', 'Penarikan - Irvan Al Rasyid (SP 16 05 00099)', '0', 8000.00, 92000.00),
('TRANS027', 'SP 16 05 00099', '2024-08-02', 'Transfer - Irvan Al Rasyid (SP 16 05 00099)', '1', 12000.00, 80000.00),
('TRANS028', 'SP 16 05 00099', '2024-08-02', 'Penarikan - Irvan Al Rasyid (SP 16 05 00099)', '0', 7000.00, 73000.00),
('TRANS029', 'SP 16 05 00099', '2024-08-02', 'Transfer - Irvan Al Rasyid (SP 16 05 00099)', '1', 30000.00, 43000.00),
('TRANS030', 'SP 16 05 00099', '2024-08-02', 'Penarikan - Irvan Al Rasyid (SP 16 05 00099)', '0', 10000.00, 33000.00),
('TRANS031', 'SP 16 05 00099', '2024-08-03', 'Transfer - Irvan Al Rasyid (SP 16 05 00099)', '1', 5000.00, 28000.00),
('TRANS032', 'SP 16 05 00099', '2024-08-03', 'Penarikan - Irvan Al Rasyid (SP 16 05 00099)', '0', 5000.00, 23000.00),
('TRANS033', 'SP 16 05 00099', '2024-08-03', 'Transfer - Irvan Al Rasyid (SP 16 05 00099)', '1', 15000.00, 8000.00),
('TRANS034', 'SP 16 05 00099', '2024-08-03', 'Penarikan - Irvan Al Rasyid (SP 16 05 00099)', '0', 5000.00, 3000.00),
('TRANS035', 'SP 16 05 00099', '2024-08-03', 'Transfer - Irvan Al Rasyid (SP 16 05 00099)', '1', 2000.00, 1000.00),
('TRANS036', 'SP 16 05 00099', '2024-08-04', 'Penarikan - Irvan Al Rasyid (SP 16 05 00099)', '0', 1000.00, 0.00),
('TRANS037', 'SP 16 05 00099', '2024-08-04', 'Transfer - Irvan Al Rasyid (SP 16 05 00099)', '1', 10000.00, 10000.00),
('TRANS038', 'SP 16 05 00099', '2024-08-04', 'Penarikan - Irvan Al Rasyid (SP 16 05 00099)', '0', 2000.00, 8000.00),
('TRANS039', 'SP 16 05 00099', '2024-08-04', 'Transfer - Irvan Al Rasyid (SP 16 05 00099)', '1', 4000.00, 12000.00),
('TRANS040', 'SP 16 05 00099', '2024-08-04', 'Penarikan - Irvan Al Rasyid (SP 16 05 00099)', '0', 2000.00, 10000.00);

-- Menambahkan data ke tabel transaksi untuk kodeSimpanan 'SW 16 05 00099'
INSERT INTO transaksi (kode_transaksi, kode_simpanan, tanggal_transaksi, deskripsi_transaksi, arah_transaksi, nilai_transaksi, saldo_akhir_transaksi) VALUES
('TRANS041', 'SW 16 05 00099', '2024-08-01', 'Transfer - Irvan Al Rasyid (SW 16 05 00099)', '1', 40000.00, 380000.00),
('TRANS042', 'SW 16 05 00099', '2024-08-01', 'Penarikan - Irvan Al Rasyid (SW 16 05 00099)', '0', 5000.00, 375000.00),
('TRANS043', 'SW 16 05 00099', '2024-08-01', 'Transfer - Irvan Al Rasyid (SW 16 05 00099)', '1', 30000.00, 345000.00),
('TRANS044', 'SW 16 05 00099', '2024-08-01', 'Penarikan - Irvan Al Rasyid (SW 16 05 00099)', '0', 10000.00, 335000.00),
('TRANS045', 'SW 16 05 00099', '2024-08-01', 'Transfer - Irvan Al Rasyid (SW 16 05 00099)', '1', 15000.00, 320000.00),
('TRANS046', 'SW 16 05 00099', '2024-08-02', 'Penarikan - Irvan Al Rasyid (SW 16 05 00099)', '0', 8000.00, 312000.00),
('TRANS047', 'SW 16 05 00099', '2024-08-02', 'Transfer - Irvan Al Rasyid (SW 16 05 00099)', '1', 20000.00, 292000.00),
('TRANS048', 'SW 16 05 00099', '2024-08-02', 'Penarikan - Irvan Al Rasyid (SW 16 05 00099)', '0', 5000.00, 287000.00),
('TRANS049', 'SW 16 05 00099', '2024-08-02', 'Transfer - Irvan Al Rasyid (SW 16 05 00099)', '1', 10000.00, 277000.00),
('TRANS050', 'SW 16 05 00099', '2024-08-02', 'Penarikan - Irvan Al Rasyid (SW 16 05 00099)', '0', 2000.00, 275000.00),
('TRANS051', 'SW 16 05 00099', '2024-08-03', 'Transfer - Irvan Al Rasyid (SW 16 05 00099)', '1', 5000.00, 270000.00),
('TRANS052', 'SW 16 05 00099', '2024-08-03', 'Penarikan - Irvan Al Rasyid (SW 16 05 00099)', '0', 3000.00, 267000.00),
('TRANS053', 'SW 16 05 00099', '2024-08-03', 'Transfer - Irvan Al Rasyid (SW 16 05 00099)', '1', 7000.00, 260000.00),
('TRANS054', 'SW 16 05 00099', '2024-08-03', 'Penarikan - Irvan Al Rasyid (SW 16 05 00099)', '0', 15000.00, 245000.00),
('TRANS055', 'SW 16 05 00099', '2024-08-03', 'Transfer - Irvan Al Rasyid (SW 16 05 00099)', '1', 10000.00, 235000.00),
('TRANS056', 'SW 16 05 00099', '2024-08-04', 'Penarikan - Irvan Al Rasyid (SW 16 05 00099)', '0', 20000.00, 215000.00),
('TRANS057', 'SW 16 05 00099', '2024-08-04', 'Transfer - Irvan Al Rasyid (SW 16 05 00099)', '1', 5000.00, 210000.00),
('TRANS058', 'SW 16 05 00099', '2024-08-04', 'Penarikan - Irvan Al Rasyid (SW 16 05 00099)', '0', 10000.00, 200000.00),
('TRANS059', 'SW 16 05 00099', '2024-08-04', 'Transfer - Irvan Al Rasyid (SW 16 05 00099)', '1', 30000.00, 170000.00),
('TRANS060', 'SW 16 05 00099', '2024-08-04', 'Penarikan - Irvan Al Rasyid (SW 16 05 00099)', '0', 20000.00, 150000.00);

-- Menambahkan data ke tabel produk_deposito
INSERT INTO produk_deposito (kode_deposito, kode_cabang, nama_produk_deposito) VALUES 
('2036625026', '00', 'SIMPANAN BERJANGKA 3 BULAN');

-- Menambahkan data ke tabel deposito
INSERT INTO deposito (kode_bilyet_deposito, kode_deposito, tanggal_mulai_deposito, tanggal_akhir_deposito, aro_deposito, saldo_deposito) VALUES 
('123456', '2036625026', '2024-01-01', '2024-06-30', 1, 1000000.00);

-- Menambahkan data ke tabel produk_pembiayaan
INSERT INTO produk_pembiayaan (kode_pembiayaan, kode_cabang, nama_produk_pembiayaan) VALUES 
('09MRJP03229', '00', 'MURABAHAH JANGKA PANJANG'),
('2036625026', '00', 'MURABAHAH JANGKA PENDEK');

-- Menambahkan data ke tabel pembiayaan
INSERT INTO pembiayaan (kontrak, kode_pembiayaan, tanggal_kontrak_pembiayaan, pokok_pembiayaan, margin_pembiayaan, bunga_pembiayaan, jangka_waktu_pembiayaan, tipe_jangka_waktu_pembiayaan, nama_jangka_waktu_pembiayaan) VALUES
('09MRJP03229', '09MRJP03229', '2024-01-01', 13000000.00, 7800000.00, 30, 24, 1, 'BULAN'),
('123456', '2036625026', '2024-02-01', 1000000.00, 100000.00, 12, 10, 1, 'BULAN');
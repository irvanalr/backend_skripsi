-- Membuat tabel token
CREATE TABLE token (
    token_value VARCHAR(255) PRIMARY KEY,                                             
    tanggal_di_buat DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL, 
    tanggal_kadaluarsa DATETIME NOT NULL,
    status ENUM('active', 'inactive', 'revoked') DEFAULT 'active' NOT NULL
);

-- Membuat tabel otentikasi
CREATE TABLE otentikasi (
    nama_pengguna VARCHAR(255) PRIMARY KEY,
    token_value VARCHAR(255) NOT NULL,
    kata_sandi VARCHAR(255) NOT NULL,
    pin VARCHAR(6) NOT NULL,
    aktivasi ENUM('active', 'inactive', 'revoked') DEFAULT 'active' NOT NULL,
    FOREIGN KEY (token_value) REFERENCES token(token_value)
);

-- Membuat tabel informasi_user
CREATE TABLE informasi_user (
    email VARCHAR(255) PRIMARY KEY,
    nama_pengguna VARCHAR(255) NOT NULL,
    nama VARCHAR(255) NOT NULL,
    no_hp VARCHAR(20) NOT NULL,
    jenis_kelamin VARCHAR(10) NOT NULL,
    tanggal_lahir DATE NOT NULL,
    registrasi DATE NOT NULL,
    kode_akun VARCHAR(10) NOT NULL,
    FOREIGN KEY (nama_pengguna) REFERENCES otentikasi(nama_pengguna)
);

-- Membuat tabel alamat_user
CREATE TABLE alamat_user (
    kode_pos VARCHAR(10) PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    alamat VARCHAR(255) NOT NULL,
    kota VARCHAR(100) NOT NULL,
    FOREIGN KEY (email) REFERENCES informasi_user(email)
);

-- Membuat tabel perusahaan
CREATE TABLE perusahaan (
    kode_perusahaan VARCHAR(20) PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    perusahaan VARCHAR(255) NOT NULL,
    FOREIGN KEY (email) REFERENCES informasi_user(email)
);

CREATE TABLE cabang (
    kode_cabang VARCHAR(20) PRIMARY KEY,
    kode_perusahaan VARCHAR(20) NOT NULL,
    cabang VARCHAR(255) NOT NULL,
    FOREIGN KEY (kode_perusahaan) REFERENCES perusahaan(kode_perusahaan)
);

-- Membuat tabel produk_simpanan
CREATE TABLE produk_simpanan (
    kode_simpanan VARCHAR(20) PRIMARY KEY,
    kode_cabang VARCHAR(20) NOT NULL,
    nama_produk_simpanan VARCHAR(255) NOT NULL,
    FOREIGN KEY (kode_cabang) REFERENCES cabang(kode_cabang)
);

-- Membuat tabel simpanan
CREATE TABLE simpanan (
    id_simpanan INT AUTO_INCREMENT PRIMARY KEY,
    kode_simpanan VARCHAR(20) NOT NULL,
    skema_produk VARCHAR(50) NOT NULL,
    tanggal_di_buat DATETIME NOT NULL,
    saldo_simpanan DECIMAL(15, 2) NOT NULL,
    FOREIGN KEY (kode_simpanan) REFERENCES produk_simpanan(kode_simpanan)
);

-- Membuat tabel transaksi
CREATE TABLE transaksi (
    kode_transaksi VARCHAR(20) PRIMARY KEY,
    kode_simpanan VARCHAR(20) NOT NULL,
    tanggal_transaksi DATE NOT NULL,
    deskripsi_transaksi VARCHAR(255) NOT NULL,
    arah_transaksi ENUM('1', '0') NOT NULL,
    nilai_transaksi DECIMAL(15, 2) NOT NULL,
    saldo_akhir_transaksi DECIMAL(15, 2) NOT NULL,
    FOREIGN KEY (kode_simpanan) REFERENCES produk_simpanan(kode_simpanan)
);

-- Membuat tabel produk_deposito
CREATE TABLE produk_deposito (
    kode_deposito VARCHAR(20) PRIMARY KEY,
    kode_cabang VARCHAR(20) NOT NULL,
    nama_produk_deposito VARCHAR(255) NOT NULL,
    FOREIGN KEY (kode_cabang) REFERENCES cabang(kode_cabang)
);

-- Membuat tabel deposito
CREATE TABLE deposito (
    kode_bilyet_deposito VARCHAR(20) PRIMARY KEY,
    kode_deposito VARCHAR(20) NOT NULL,
    tanggal_mulai_deposito DATE NOT NULL,
    tanggal_akhir_deposito DATE NOT NULL,
    aro_deposito INT NOT NULL,
    saldo_deposito DECIMAL(15, 2) NOT NULL,
    FOREIGN KEY (kode_deposito) REFERENCES produk_deposito(kode_deposito)
);

-- Membuat tabel produk_pembiayaan
CREATE TABLE produk_pembiayaan (
    Kode_pembiayaan VARCHAR(20) PRIMARY KEY,
    kode_cabang VARCHAR(20) NOT NULL,
    nama_produk_pembiayaan VARCHAR(255) NOT NULL,
    FOREIGN KEY (kode_cabang) REFERENCES cabang(kode_cabang)
);

-- Membuat tabel pembiayaan
CREATE TABLE pembiayaan (
    kontrak VARCHAR(20) PRIMARY KEY,
    kode_pembiayaan VARCHAR(20) NOT NULL,
    tanggal_kontrak_pembiayaan DATE NOT NULL,
    pokok_pembiayaan DECIMAL(15, 2) NOT NULL,
    margin_pembiayaan DECIMAL(15, 2) NOT NULL,
    bunga_pembiayaan INT NOT NULL,
    jangka_waktu_pembiayaan INT NOT NULL,
    tipe_jangka_waktu_pembiayaan INT NOT NULL,
    nama_jangka_waktu_pembiayaan VARCHAR(50) NOT NULL,
    FOREIGN KEY (kode_pembiayaan) REFERENCES produk_pembiayaan(kode_pembiayaan)
);

-- Menambahkan data ke tabel token
INSERT INTO token (token_value, tanggal_kadaluarsa, tanggal_di_buat, status) VALUES
('kkpPerbankan', '2024-09-01 12:00:00', '2024-08-20 10:00:00', 'active');

-- Menambahkan data ke tabel otentikasi
INSERT INTO otentikasi (nama_pengguna, token_value, kata_sandi, pin, aktivasi) VALUES
('irvan', 'kkpPerbankan', 'irvan123', '123456', 'active'),
('budi','kkpPerbankan', 'budi123', '123456', 'active');

-- Menambahkan data ke tabel informasi_user
INSERT INTO informasi_user (email, nama_pengguna, nama, no_hp, jenis_kelamin, tanggal_lahir, registrasi, kode_akun) VALUES
('irvan@gmail.com', 'irvan', 'Irvan Al Rasyid', '081234567890', 'Laki-laki', '2000-10-15', '2023-08-20', '10000213'),
('budi@gmail.com', 'budi', 'Ini budi', '021234567891', 'Laki-laki', '2000-10-20', '2024-09-20', '30000231');

-- Menambahkan data ke tabel alamat_user
INSERT INTO alamat_user (kode_pos, email, alamat, kota) VALUES 
('12345', 'irvan@gmail.com', 'Jl. Raya No. 1', 'Jakarta'),
('54321', 'budi@gmail.com', 'JL. Raya No. 3', 'Tanggerang selatan');

-- Menambahkan data ke tabel perusahaan
INSERT INTO perusahaan (kode_perusahaan, email, perusahaan) VALUES
('998', 'irvan@gmail.com', 'KOPERASI SYARIAH DEMO'),
('887', 'budi@gmail.com', 'KOPERASI SYARIAH DEMO');

-- Menambahkan data ke tabel cabang
INSERT INTO cabang (kode_cabang, kode_perusahaan, cabang) VALUES
('00', '998', 'PUSAT'),
('11', '887', 'PUSAT');

-- Menambahkan data ke tabel produk_simpanan
INSERT INTO produk_simpanan (kode_simpanan, kode_cabang, nama_produk_simpanan) VALUES 
('116 04 5063', '00', 'TABUNGAN SIMPATI'),
('SP 16 05 00099', '00', 'SIMPANAN POKOK'),
('SW 16 05 00099', '00', 'SIMPANAN WAJIB'),
('116 04 5002', '11', 'TABUNGAN SIMPATI'),
('SP 16 05 00002', '11', 'SIMPANAN POKOK'),
('SW 16 05 00002', '11', 'SIMPANAN WAJIB');

-- Menambahkan data ke tabel simpanan
INSERT INTO simpanan (kode_simpanan, skema_produk, tanggal_di_buat, saldo_simpanan) VALUES
('116 04 5063', 'WADIAH', '2020-05-08', 4209596.00),
('SP 16 05 00099', 'POKOK WAJIB', '2020-06-08', 100000.00),
('SW 16 05 00099', 'POKOK WAJIB', '2020-07-08', 420000.00),
('116 04 5002', 'WADIAH', '2020-05-08', 4209596.00),
('SP 16 05 00002', 'POKOK WAJIB', '2020-06-08', 100000.00),
('SW 16 05 00002', 'POKOK WAJIB', '2020-07-08', 420000.00);

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

-- Menambahkan data ke tabel transaksi untuk kodeSimpanan '116 04 5002'
INSERT INTO transaksi (kode_transaksi, kode_simpanan, tanggal_transaksi, deskripsi_transaksi, arah_transaksi, nilai_transaksi, saldo_akhir_transaksi) VALUES
('TRANS061', '116 04 5002', '2024-08-01', 'Transfer - Irvan Al Rasyid (116 04 5002)', '1', 500000.00, 4709596.00),
('TRANS062', '116 04 5002', '2024-08-01', 'Penarikan - Irvan Al Rasyid (116 04 5002)', '0', 100000.00, 4609596.00),
('TRANS063', '116 04 5002', '2024-08-01', 'Transfer - Irvan Al Rasyid (116 04 5002)', '1', 200000.00, 4409596.00),
('TRANS064', '116 04 5002', '2024-08-01', 'Penarikan - Irvan Al Rasyid (116 04 5002)', '0', 150000.00, 4259596.00),
('TRANS065', '116 04 5002', '2024-08-01', 'Transfer - Irvan Al Rasyid (116 04 5002)', '1', 300000.00, 3959596.00),
('TRANS066', '116 04 5002', '2024-08-02', 'Penarikan - Irvan Al Rasyid (116 04 5002)', '0', 50000.00, 3909596.00),
('TRANS067', '116 04 5002', '2024-08-02', 'Transfer - Irvan Al Rasyid (116 04 5002)', '1', 250000.00, 3659596.00),
('TRANS068', '116 04 5002', '2024-08-02', 'Penarikan - Irvan Al Rasyid (116 04 5002)', '0', 200000.00, 3459596.00),
('TRANS069', '116 04 5002', '2024-08-02', 'Transfer - Irvan Al Rasyid (116 04 5002)', '1', 100000.00, 3359596.00),
('TRANS070', '116 04 5002', '2024-08-02', 'Penarikan - Irvan Al Rasyid (116 04 5002)', '0', 100000.00, 3259596.00),
('TRANS071', '116 04 5002', '2024-08-03', 'Transfer - Irvan Al Rasyid (116 04 5002)', '1', 150000.00, 3109596.00),
('TRANS072', '116 04 5002', '2024-08-03', 'Penarikan - Irvan Al Rasyid (116 04 5002)', '0', 80000.00, 3029596.00),
('TRANS073', '116 04 5002', '2024-08-03', 'Transfer - Irvan Al Rasyid (116 04 5002)', '1', 200000.00, 2829596.00),
('TRANS074', '116 04 5002', '2024-08-03', 'Penarikan - Irvan Al Rasyid (116 04 5002)', '0', 120000.00, 2709596.00),
('TRANS075', '116 04 5002', '2024-08-03', 'Transfer - Irvan Al Rasyid (116 04 5002)', '1', 300000.00, 2409596.00),
('TRANS076', '116 04 5002', '2024-08-04', 'Penarikan - Irvan Al Rasyid (116 04 5002)', '0', 150000.00, 2259596.00),
('TRANS077', '116 04 5002', '2024-08-04', 'Transfer - Irvan Al Rasyid (116 04 5002)', '1', 400000.00, 1859596.00),
('TRANS078', '116 04 5002', '2024-08-04', 'Penarikan - Irvan Al Rasyid (116 04 5002)', '0', 250000.00, 1609596.00),
('TRANS079', '116 04 5002', '2024-08-04', 'Transfer - Irvan Al Rasyid (116 04 5002)', '1', 50000.00, 1559596.00),
('TRANS080', '116 04 5002', '2024-08-04', 'Penarikan - Irvan Al Rasyid (116 04 5002)', '0', 100000.00, 1459596.00);

-- Menambahkan data ke tabel transaksi untuk kodeSimpanan 'SP 16 05 00002'
INSERT INTO transaksi (kode_transaksi, kode_simpanan, tanggal_transaksi, deskripsi_transaksi, arah_transaksi, nilai_transaksi, saldo_akhir_transaksi) VALUES
('TRANS081', 'SP 16 05 00002', '2024-08-01', 'Transfer - Irvan Al Rasyid (SP 16 05 00002)', '1', 50000.00, 150000.00),
('TRANS082', 'SP 16 05 00002', '2024-08-01', 'Penarikan - Irvan Al Rasyid (SP 16 05 00002)', '0', 10000.00, 140000.00),
('TRANS083', 'SP 16 05 00002', '2024-08-01', 'Transfer - Irvan Al Rasyid (SP 16 05 00002)', '1', 20000.00, 120000.00),
('TRANS084', 'SP 16 05 00002', '2024-08-01', 'Penarikan - Irvan Al Rasyid (SP 16 05 00002)', '0', 5000.00, 115000.00),
('TRANS085', 'SP 16 05 00002', '2024-08-01', 'Transfer - Irvan Al Rasyid (SP 16 05 00002)', '1', 15000.00, 100000.00),
('TRANS086', 'SP 16 05 00002', '2024-08-02', 'Penarikan - Irvan Al Rasyid (SP 16 05 00002)', '0', 8000.00, 92000.00),
('TRANS087', 'SP 16 05 00002', '2024-08-02', 'Transfer - Irvan Al Rasyid (SP 16 05 00002)', '1', 12000.00, 80000.00),
('TRANS088', 'SP 16 05 00002', '2024-08-02', 'Penarikan - Irvan Al Rasyid (SP 16 05 00002)', '0', 7000.00, 73000.00),
('TRANS089', 'SP 16 05 00002', '2024-08-02', 'Transfer - Irvan Al Rasyid (SP 16 05 00002)', '1', 30000.00, 43000.00),
('TRANS090', 'SP 16 05 00002', '2024-08-02', 'Penarikan - Irvan Al Rasyid (SP 16 05 00002)', '0', 10000.00, 33000.00),
('TRANS091', 'SP 16 05 00002', '2024-08-03', 'Transfer - Irvan Al Rasyid (SP 16 05 00002)', '1', 5000.00, 28000.00),
('TRANS092', 'SP 16 05 00002', '2024-08-03', 'Penarikan - Irvan Al Rasyid (SP 16 05 00002)', '0', 5000.00, 23000.00),
('TRANS093', 'SP 16 05 00002', '2024-08-03', 'Transfer - Irvan Al Rasyid (SP 16 05 00002)', '1', 15000.00, 8000.00),
('TRANS094', 'SP 16 05 00002', '2024-08-03', 'Penarikan - Irvan Al Rasyid (SP 16 05 00002)', '0', 5000.00, 3000.00),
('TRANS095', 'SP 16 05 00002', '2024-08-03', 'Transfer - Irvan Al Rasyid (SP 16 05 00002)', '1', 2000.00, 1000.00),
('TRANS096', 'SP 16 05 00002', '2024-08-04', 'Penarikan - Irvan Al Rasyid (SP 16 05 00002)', '0', 1000.00, 0.00),
('TRANS097', 'SP 16 05 00002', '2024-08-04', 'Transfer - Irvan Al Rasyid (SP 16 05 00002)', '1', 10000.00, 10000.00),
('TRANS098', 'SP 16 05 00002', '2024-08-04', 'Penarikan - Irvan Al Rasyid (SP 16 05 00002)', '0', 2000.00, 8000.00),
('TRANS099', 'SP 16 05 00002', '2024-08-04', 'Transfer - Irvan Al Rasyid (SP 16 05 00002)', '1', 4000.00, 12000.00),
('TRANS0100', 'SP 16 05 00002', '2024-08-04', 'Penarikan - Irvan Al Rasyid (SP 16 05 00002)', '0', 2000.00, 10000.00);

-- Menambahkan data ke tabel transaksi untuk kodeSimpanan 'SW 16 05 00002'
INSERT INTO transaksi (kode_transaksi, kode_simpanan, tanggal_transaksi, deskripsi_transaksi, arah_transaksi, nilai_transaksi, saldo_akhir_transaksi) VALUES
('TRANS0101', 'SW 16 05 00002', '2024-08-01', 'Transfer - Irvan Al Rasyid (SW 16 05 00002)', '1', 40000.00, 380000.00),
('TRANS0102', 'SW 16 05 00002', '2024-08-01', 'Penarikan - Irvan Al Rasyid (SW 16 05 00002)', '0', 5000.00, 375000.00),
('TRANS0103', 'SW 16 05 00002', '2024-08-01', 'Transfer - Irvan Al Rasyid (SW 16 05 00002)', '1', 30000.00, 345000.00),
('TRANS0104', 'SW 16 05 00002', '2024-08-01', 'Penarikan - Irvan Al Rasyid (SW 16 05 00002)', '0', 10000.00, 335000.00),
('TRANS0105', 'SW 16 05 00002', '2024-08-01', 'Transfer - Irvan Al Rasyid (SW 16 05 00002)', '1', 15000.00, 320000.00),
('TRANS0106', 'SW 16 05 00002', '2024-08-02', 'Penarikan - Irvan Al Rasyid (SW 16 05 00002)', '0', 8000.00, 312000.00),
('TRANS0107', 'SW 16 05 00002', '2024-08-02', 'Transfer - Irvan Al Rasyid (SW 16 05 00002)', '1', 20000.00, 292000.00),
('TRANS0108', 'SW 16 05 00002', '2024-08-02', 'Penarikan - Irvan Al Rasyid (SW 16 05 00002)', '0', 5000.00, 287000.00),
('TRANS0109', 'SW 16 05 00002', '2024-08-02', 'Transfer - Irvan Al Rasyid (SW 16 05 00002)', '1', 10000.00, 277000.00),
('TRANS0110', 'SW 16 05 00002', '2024-08-02', 'Penarikan - Irvan Al Rasyid (SW 16 05 00002)', '0', 2000.00, 275000.00),
('TRANS0111', 'SW 16 05 00002', '2024-08-03', 'Transfer - Irvan Al Rasyid (SW 16 05 00002)', '1', 5000.00, 270000.00),
('TRANS0112', 'SW 16 05 00002', '2024-08-03', 'Penarikan - Irvan Al Rasyid (SW 16 05 00002)', '0', 3000.00, 267000.00),
('TRANS0113', 'SW 16 05 00002', '2024-08-03', 'Transfer - Irvan Al Rasyid (SW 16 05 00002)', '1', 7000.00, 260000.00),
('TRANS0114', 'SW 16 05 00002', '2024-08-03', 'Penarikan - Irvan Al Rasyid (SW 16 05 00002)', '0', 15000.00, 245000.00),
('TRANS0115', 'SW 16 05 00002', '2024-08-03', 'Transfer - Irvan Al Rasyid (SW 16 05 00002)', '1', 10000.00, 235000.00),
('TRANS0116', 'SW 16 05 00002', '2024-08-04', 'Penarikan - Irvan Al Rasyid (SW 16 05 00002)', '0', 20000.00, 215000.00),
('TRANS0117', 'SW 16 05 00002', '2024-08-04', 'Transfer - Irvan Al Rasyid (SW 16 05 00002)', '1', 5000.00, 210000.00),
('TRANS0118', 'SW 16 05 00002', '2024-08-04', 'Penarikan - Irvan Al Rasyid (SW 16 05 00002)', '0', 10000.00, 200000.00),
('TRANS0119', 'SW 16 05 00002', '2024-08-04', 'Transfer - Irvan Al Rasyid (SW 16 05 00002)', '1', 30000.00, 170000.00),
('TRANS0120', 'SW 16 05 00002', '2024-08-04', 'Penarikan - Irvan Al Rasyid (SW 16 05 00002)', '0', 20000.00, 150000.00);


-- Menambahkan data ke tabel produk_deposito
INSERT INTO produk_deposito (kode_deposito, kode_cabang, nama_produk_deposito) VALUES 
('2036625026', '00', 'SIMPANAN BERJANGKA 3 BULAN'),
('1025514015', '11', 'SIMPANAN BERJANGKA 6 BULAN');

-- Menambahkan data ke tabel deposito
INSERT INTO deposito (kode_bilyet_deposito, kode_deposito, tanggal_mulai_deposito, tanggal_akhir_deposito, aro_deposito, saldo_deposito) VALUES 
('123456', '2036625026', '2024-01-01', '2024-06-30', 1, 1000000.00),
('654321', '1025514015', '2024-01-01', '2024-06-30', 1, 3000000.00);

-- Menambahkan data ke tabel produk_pembiayaan
INSERT INTO produk_pembiayaan (kode_pembiayaan, kode_cabang, nama_produk_pembiayaan) VALUES 
('09MRJP03229', '00', 'MURABAHAH JANGKA PANJANG'),
('2036625026', '00', 'MURABAHAH JANGKA PENDEK'),
('08MRJP02118', '11', 'MURABAHAH JANGKA PANJANG'),
('1024514015', '11', 'MURABAHAH JANGKA PENDEK');

-- Menambahkan data ke tabel pembiayaan
INSERT INTO pembiayaan (kontrak, kode_pembiayaan, tanggal_kontrak_pembiayaan, pokok_pembiayaan, margin_pembiayaan, bunga_pembiayaan, jangka_waktu_pembiayaan, tipe_jangka_waktu_pembiayaan, nama_jangka_waktu_pembiayaan) VALUES
('09MRJP03229', '09MRJP03229', '2024-01-01', 13000000.00, 7800000.00, 30, 24, 1, 'BULAN'),
('123456', '2036625026', '2024-02-01', 1000000.00, 100000.00, 12, 10, 1, 'BULAN'),
('0123456', '08MRJP02118', '2024-01-01', 14000000.00, 8800000.00, 20, 14, 1, 'BULAN'),
('6543210', '1024514015', '2024-02-01', 2000000.00, 200000.00, 11, 9, 1, 'BULAN');
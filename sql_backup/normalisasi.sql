-- Membuat tabel token
CREATE TABLE token (
    tokenId INT PRIMARY KEY,
    tokenName VARCHAR(255),
    kadaluarsa DATE
);

-- Membuat table otentikasi
CREATE TABLE otentikasi (
    namaPengguna VARCHAR(255) PRIMARY KEY,
    kataSandi VARCHAR(255),
    pin VARCHAR(6),
    email VARCHAR(255) UNIQUE,
    FOREIGN KEY (email) REFERENCES informasi_user(email)
);

-- Membuat table informasi user
CREATE TABLE informasi_user (
    email VARCHAR(255) PRIMARY KEY,
    nama VARCHAR(255),
    handphone VARCHAR(20),
    jenisKelamin VARCHAR(10),
    tanggalLahir DATE,
    alamat VARCHAR(255),
    kota VARCHAR(100),
    kodePos VARCHAR(10),
    registrasi DATE
);

-- Membuat table perusahaan cabang
CREATE TABLE perusahaan_cabang (
    kodePerusahaan VARCHAR(20) PRIMARY KEY,
    perusahaan VARCHAR(255),
    kodeCabang VARCHAR(20),
    cabang VARCHAR(255),
);

-- Membuat table simpanan
CREATE TABLE simpanan (
    kodeSimpanan VARCHAR(20) PRIMARY KEY,
    namaProdukSimpanan VARCHAR(255),
    saldoSimpanan DECIMAL(15, 2),
    kodePerusahaan VARCHAR(20),
    FOREIGN KEY (kodePerusahaan) REFERENCES perusahaan_cabang(kodePerusahaan)
);

-- Membuat table transaksi
CREATE TABLE transaksi (
    kodeTransaksi VARCHAR(20) PRIMARY KEY,
    tanggalTransaksi DATE,
    deskripsiTransaksi VARCHAR(255),
    arahTransaksi ENUM('masuk', 'keluar'),
    nilaiTransaksi DECIMAL(15, 2),
    saldoAkhirTransaksi DECIMAL(15, 2),
    kodeSimpanan VARCHAR(20),
    FOREIGN KEY (kodeSimpanan) REFERENCES simpanan(kodeSimpanan)
);

-- Membuat table produk deposito
CREATE TABLE produk_deposito (
    kodeDeposito VARCHAR(20) PRIMARY KEY,
    namaProdukDeposito VARCHAR(255)
);

-- Membuat table deposito
CREATE TABLE deposito (
    kodeBilyetDeposito VARCHAR(20) PRIMARY KEY,
    kodeDeposito VARCHAR(20),
    tanggalMulaiDeposito DATE,
    tanggalAkhirDeposito DATE,
    aroDeposito INT,
    saldoDeposito DECIMAL(15, 2),
    FOREIGN KEY (kodeDeposito) REFERENCES produkDeposito(kodeDeposito)
);

-- Membuat table produk pembiayaan
CREATE TABLE produk_pembiayaan (
    kodePembiayaan VARCHAR(20) PRIMARY KEY,
    namaProdukPembiayaan VARCHAR(255)
);

-- Membuat table pembiayaan
CREATE TABLE pembiayaan (
    kodeKontrakPembiayaan VARCHAR(20) PRIMARY KEY,
    kodePembiayaan VARCHAR(20),
    tanggalKontrakPembiayaan DATE,
    pokokPembiayaan DECIMAL(15, 2),
    marginPembiayaan DECIMAL(15, 2),
    bungaPembiayaan DECIMAL(5, 2),
    jangkaWaktuPembiayaan INT,
    tipeJangkaWaktuPembiayaan INT,
    namaJangkaWaktuPembiayaan VARCHAR(50),
    FOREIGN KEY (kodePembiayaan) REFERENCES produkPembiayaan(kodePembiayaan)
);




-- Membuat tabel users
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    token_id INT NOT NULL,
    aktivasi TINYINT(1) NOT NULL,
    status TINYINT(1) NOT NULL,
    username VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    pin VARCHAR(12) NOT NULL,
    FOREIGN KEY (token_id) REFERENCES tokens(id)
);

-- Membuat tabel user_activities
CREATE TABLE user_activities (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    token_id INT NOT NULL,
    timestamp_login DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    timestamp_logout DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total_login INT NOT NULL,
    total_logout INT NOT NULL,
    failed_login_attempts INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (token_id) REFERENCES tokens(id)
);

-- Membuat tabel user_informations
CREATE TABLE user_informations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    token_id INT NOT NULL,
    company_code VARCHAR(255) NOT NULL,
    company VARCHAR(255) NOT NULL,
    branch VARCHAR(255) NOT NULL,
    code VARCHAR(14) UNIQUE,
    timestamp_registration DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    name VARCHAR(255) NOT NULL,
    handphone VARCHAR(13) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    dob VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,
    postcode VARCHAR(5) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (token_id) REFERENCES tokens(id)
);

-- Membuat table rekening_utama_users
CREATE TABLE rekening_utama_users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    token_id INT NOT NULL,
    timestamp_registration DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    product_name VARCHAR(255) NOT NULL,
    code VARCHAR(14) UNIQUE,
    name VARCHAR(255) NOT NULL,
    balance INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (token_id) REFERENCES tokens(id)
);

-- Membuat table list tabungan simpanan
CREATE TABLE list_tabungan_simpanan_users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    token_id INT NOT NULL,
    timestamp_registration DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    product_name VARCHAR(255) NOT NULL,
    code VARCHAR(14) UNIQUE,
    name VARCHAR(255) NOT NULL,
    balance INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (token_id) REFERENCES tokens(id)
);

-- Membuat table list rekening deposito simpanan berjangka
CREATE TABLE list_rekening_deposito_simpanan_berjangka (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    token_id INT NOT NULL,
    code VARCHAR(20) NOT NULL UNIQUE,
    product_name VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    bilyet VARCHAR(20) NOT NULL,
    timestamp_begin DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    timestamp_end DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    value INT NOT NULL,
    aro TINYINT(1) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (token_id) REFERENCES tokens(id)
);

-- Membuat table list rekening pembiayaan
CREATE TABLE list_rekening_pembiayaan (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    token_id INT NOT NULL,
    code VARCHAR(20) NOT NULL UNIQUE,
    product_name VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    contract VARCHAR(255) NOT NULL,
    timestamp_contract DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    principal INT NOT NULL,
    margin INT NOT NULL,
    rate INT NOT NULL,
    tenor INT NOT NULL,
    tenor_type INT NOT NULL,
    tenor_name VARCHAR(10) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (token_id) REFERENCES tokens(id)
);

-- Membuat table list transaksi
CREATE TABLE list_transaksi_simpanan (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    token_id INT NOT NULL,
    timestamp_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    code VARCHAR(255) NOT NULL,
    description VARCHAR(255) NOT NULL,
    direction TINYINT(1) NOT NULL,
    value1 INT NOT NULL,
    end_value1 INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (token_id) REFERENCES tokens(id)
);

-- Membuat table informasi_rekening_simpanan
CREATE TABLE informasi_rekening_simpanan (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    token_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    company_code VARCHAR(255) NOT NULL,
    company VARCHAR(255) NOT NULL,
    branch_code VARCHAR(255) NOT NULL,
    branch VARCHAR(255) NOT NULL,
    code VARCHAR(255) NOT NULL,
    timestamp_registration DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    product_name VARCHAR(255) NOT NULL,
    product_scheme VARCHAR(255) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (token_id) REFERENCES tokens(id)
);

-- Menyisipkan data ke tabel tokens
INSERT INTO tokens (token_id, status, timestamp_create, timestamp_expired)
VALUES ('kkp_perbankan', 1, '2024-07-11 19:02:00', '2024-08-11 19:02:00');

-- Menyisipkan data ke tabel users
INSERT INTO users (token_id, aktivasi, status, username, password, pin)
VALUES (1, 1, 1, 'irvan', 'irvan123', '457812'),
       (1, 1, 1, 'bagas', 'bagas123', '123456');

-- Menyisipkan data ke tabel user_activities
INSERT INTO user_activities (user_id, token_id, timestamp_login, timestamp_logout, total_login, total_logout, failed_login_attempts)
VALUES (1, 1, '2024-07-22 15:26:00', '2024-07-20 07:31:00', 24, 6, 2),
       (2, 1, '2024-07-22 15:08:00', '2024-07-22 13:24:00', 32, 3, 2);

-- Menyisipkan data ke tabel user_informations
INSERT INTO user_informations (user_id, token_id, company_code, company, branch, code, timestamp_registration, name, handphone, email, gender, dob, city, address, postcode)
VALUES (1, 1, '998', 'KOPERASI SYARIAH DEMO', 'PUSAT', '0010000213', '2024-07-22 15:26:00', 'Irvan Al Rasyid', '0811231231231', 'irvan@gmail.com', 'Laki-Laki', '2000-08-12', 'Depok', 'JL ABC No 123', '15412'),
       (2, 1, '887', 'KOPERASI SYARIAH DEMO', 'PUSAT', '0010000212', '2024-07-22 15:26:00', 'Bagas Jumadi', '0212312312321', 'bagas@gmail.com', 'Laki-Laki', '2001-07-15', 'Jakarta', 'JL CBA No 321','51142');


-- Menyisipkan data ke table rekening_utama_users
INSERT INTO rekening_utama_users (user_id, token_id, timestamp_registration, product_name, code, name, balance)
VALUES (1, 1, '2024-07-22 15:26:00', 'TABUNGAN SIMPATI', '116 04 5063', 'Irvan Al Rasyid', 4209596),
       (2, 1, '2024-07-22 15:26:00', 'TABUNGAN SIMPATI', '117 05 6174', 'Bagas Jumadi', 5320707);

-- Menyisipkan data ke table list_tabungan_simpanan_users 
INSERT INTO  list_tabungan_simpanan_users (user_id, token_id, timestamp_registration, product_name, code, name, balance)
VALUES (1, 1, '2024-07-22 15:26:00', 'TABUNGAN SIMPATI', '116 04 5063', 'Irvan Al Rasyid', 4209596),
       (1, 1, '2024-07-23 15:26:00', 'SIMPANAN POKOK', 'SP 116 05 0099', 'Irvan Al Rasyid', 100000),
       (1, 1, '2024-07-24 15:26:00', 'SIMPANAN WAJIB', 'SW 116 06 0098', 'Irvan Al Rasyid', 420000),
       (2, 1, '2024-07-22 15:26:00', 'TABUNGAN SIMPATI', '116 14 5063', 'Bagas Jumadi', 4209596),
       (2, 1, '2024-07-23 15:26:00', 'SIMPANAN POKOK', 'SP 116 15 0099', 'Bagas Jumadi', 100000),
       (2, 1, '2024-07-24 15:26:00', 'SIMPANAN WAJIB', 'SW 116 16 0098', 'Bagas Jumadi', 420000);

-- Menyisipkan data ke table list_rekening_deposito_simpanan_berjangka
INSERT INTO list_rekening_deposito_simpanan_berjangka (user_id, token_id, code, product_name, name, bilyet, timestamp_begin, timestamp_end, value, aro)
VALUES (1, 1, '2036625026', 'SIMPANAN BERJANGKA 3 BULAN', 'Irvan Al Rasyid', '123456', '2024-07-22 15:26:00', '2024-10-22 15:26:00', 1000000, 1),
       (2, 1, '3147736137', 'SIMPANAN BERJANGKA 3 BULAN', 'Bagas Jumadi', '654321', '2024-07-22 15:26:00', '2024-10-22 15:26:00', 2000000, 1);

-- Menyisipkan data ke table list_rekening_pembiayaan
INSERT INTO list_rekening_pembiayaan (user_id, token_id, code, product_name, name, contract, timestamp_contract, principal, margin, rate, tenor, tenor_type, tenor_name)
VALUES (1, 1, '09MRJP03229', 'MURABAHAH JANGKA PANJANG', 'Irvan Al Rasyid', '09MRJP03229', '2016-09-24 15:26:00', 13000000, 7800000, 30, 24, 1, 'BULAN'),
       (1, 1, '2036625026', 'MURABAHAH JANGKA PENDEK', 'Irvan Al Rasyid', '123456', '2021-07-25 15:26:00', 1000000, 100000, 12, 10, 1, 'BULAN'),
       (2, 1, '29MRJP03229', 'MURABAHAH JANGKA PANJANG', 'Bagas Jumadi', '29MRJP03229', '2016-09-24 15:26:00', 14000000, 8800000, 30, 24, 1, 'BULAN'),
       (2, 1, '4036625026', 'MURABAHAH JANGKA PENDEK', 'Bagas Jumadi', '423456', '2021-07-25 15:26:00', 2000000, 200000, 12, 10, 1, 'BULAN');

-- Menyisipkan data ke table list transaksi
INSERT INTO list_transaksi_simpanan (user_id, token_id, timestamp_date, code, description, direction, value1, end_value1)
VALUES (1, 1, '2024-08-02 15:26:00', '0001AO1000033', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (116 04 5063)', 0, 150000, 4361596),
    (1, 1, '2024-08-02 15:26:00', 'BASIL20210925', 'BASIL SEPTEMBER09/2021- Irvan Al Rasyid (116 04 5063)', 1, 120000, 4511596),
    (1, 1, '2024-08-02 15:26:00', '0001TL000002', 'SETOR TUNAI - Irvan Al Rasyid (116 04 5063)', 1, 37000, 4391596),
    (1, 1, '2024-08-02 15:26:00', '0001AO1000032', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (116 04 5063)', 0, 25000, 4354596),
    (1, 1, '2024-08-02 15:26:00', '0001AO2000003', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (116 04 5063)', 0, 23000, 4379596),
    (1, 1, '2024-08-02 15:26:00', '0001AO1000033', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (116 04 5063)', 0, 10000, 4402596),
    (1, 1, '2024-08-02 15:26:00', 'BASIL20210925', 'BASIL SEPTEMBER09/2021- Irvan Al Rasyid (116 04 5063)', 1, 120000, 4412596),
    (1, 1, '2024-08-02 15:26:00', '0001TL000002', 'SETOR TUNAI - Irvan Al Rasyid (116 04 5063)', 1, 37000, 4292596),
    (1, 1, '2024-08-02 15:26:00', '0001AO1000032', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (116 04 5063)', 0, 25000, 4255596),
    (1, 1, '2024-08-02 15:26:00', '0001AO2000003', 'SETOR TUNAI - Irvan Al Rasyid (116 04 5063)', 1, 23000, 4280596),
    (1, 1, '2024-08-02 15:26:00', '0001AO1000033', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (116 04 5063)', 0, 150000, 4257596),
    (1, 1, '2024-08-02 15:26:00', 'BASIL20210925', 'BASIL SEPTEMBER09/2021- Irvan Al Rasyid (116 04 5063)', 1, 120000, 4407596),
    (1, 1, '2024-08-02 15:26:00', '0001TL000002', 'SETOR TUNAI - Irvan Al Rasyid (116 04 5063)', 1, 37000, 4287596),
    (1, 1, '2024-08-02 15:26:00', '0001AO1000032', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (116 04 5063)', 0, 25000, 4250596),
    (1, 1, '2024-08-02 15:26:00', '0001AO2000003', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (116 04 5063)', 0, 23000, 4275596),
    (1, 1, '2024-08-02 15:26:00', '0001AO1000033', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (116 04 5063)', 0, 10000, 4298596),
    (1, 1, '2024-08-02 15:26:00', 'BASIL20210925', 'BASIL SEPTEMBER09/2021- Irvan Al Rasyid (116 04 5063)', 1, 120000, 4308596),
    (1, 1, '2024-08-02 15:26:00', '0001TL000002', 'SETOR TUNAI - Irvan Al Rasyid (116 04 5063)', 1, 37000, 4188596),
    (1, 1, '2024-08-02 15:26:00', '0001AO1000032', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (116 04 5063)', 0, 25000, 4151596),
    (1, 1, '2024-08-02 15:26:00', '0001AO2000003', 'SETOR TUNAI - Irvan Al Rasyid (116 04 5063)', 1, 23000, 4209596),

    (1, 1, '2024-08-03 15:26:00', '0001AO1000033', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (116 04 5063)', 0, 150000, 4361596),
    (1, 1, '2024-08-03 15:26:00', 'BASIL20210925', 'BASIL SEPTEMBER09/2021- Irvan Al Rasyid (116 04 5063)', 1, 120000, 4511596),
    (1, 1, '2024-08-03 15:26:00', '0001TL000002', 'SETOR TUNAI - Irvan Al Rasyid (116 04 5063)', 1, 37000, 4391596),
    (1, 1, '2024-08-03 15:26:00', '0001AO1000032', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (116 04 5063)', 0, 25000, 4354596),
    (1, 1, '2024-08-03 15:26:00', '0001AO2000003', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (116 04 5063)', 0, 23000, 4379596),
    (1, 1, '2024-08-03 15:26:00', '0001AO1000033', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (116 04 5063)', 0, 10000, 4402596),
    (1, 1, '2024-08-03 15:26:00', 'BASIL20210925', 'BASIL SEPTEMBER09/2021- Irvan Al Rasyid (116 04 5063)', 1, 120000, 4412596),
    (1, 1, '2024-08-03 15:26:00', '0001TL000002', 'SETOR TUNAI - Irvan Al Rasyid (116 04 5063)', 1, 37000, 4292596),
    (1, 1, '2024-08-03 15:26:00', '0001AO1000032', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (116 04 5063)', 0, 25000, 4255596),
    (1, 1, '2024-08-03 15:26:00', '0001AO2000003', 'SETOR TUNAI - Irvan Al Rasyid (116 04 5063)', 1, 23000, 4280596),
    (1, 1, '2024-08-03 15:26:00', '0001AO1000033', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (116 04 5063)', 0, 150000, 4257596),
    (1, 1, '2024-08-03 15:26:00', 'BASIL20210925', 'BASIL SEPTEMBER09/2021- Irvan Al Rasyid (116 04 5063)', 1, 120000, 4407596),
    (1, 1, '2024-08-03 15:26:00', '0001TL000002', 'SETOR TUNAI - Irvan Al Rasyid (116 04 5063)', 1, 37000, 4287596),
    (1, 1, '2024-08-03 15:26:00', '0001AO1000032', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (116 04 5063)', 0, 25000, 4250596),
    (1, 1, '2024-08-03 15:26:00', '0001AO2000003', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (116 04 5063)', 0, 23000, 4275596),
    (1, 1, '2024-08-03 15:26:00', '0001AO1000033', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (116 04 5063)', 0, 10000, 4298596),
    (1, 1, '2024-08-03 15:26:00', 'BASIL20210925', 'BASIL SEPTEMBER09/2021- Irvan Al Rasyid (116 04 5063)', 1, 120000, 4308596),
    (1, 1, '2024-08-03 15:26:00', '0001TL000002', 'SETOR TUNAI - Irvan Al Rasyid (116 04 5063)', 1, 37000, 4188596),
    (1, 1, '2024-08-03 15:26:00', '0001AO1000032', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (116 04 5063)', 0, 25000, 4151596),
    (1, 1, '2024-08-03 15:26:00', '0001AO2000003', 'SETOR TUNAI - Irvan Al Rasyid (116 04 5063)', 1, 23000, 4209596),

    (1, 1, '2024-08-02 15:26:00', '0001TL000002', 'SETOR TUNAI - Irvan Al Rasyid (SP 116 05 0099)', 1, 37000, 5000000),
    (1, 1, '2024-08-02 15:26:00', 'BASIL20210925', 'BASIL SEPTEMBER09/2021- Irvan Al Rasyid (SP 116 05 0099)', 1, 120000, 5120000),
    (1, 1, '2024-08-02 15:26:00', '0001AO1000033', 'SETOR TUNAI - Irvan Al Rasyid (SP 116 05 0099)', 1, 10000, 5130000),
    (1, 1, '2024-08-02 15:26:00', '0001AO2000003', 'SETOR TUNAI - Irvan Al Rasyid (SP 116 05 0099)', 1, 23000, 5153000),
    (1, 1, '2024-08-02 15:26:00', '0001AO1000032', 'SETOR TUNAI - Irvan Al Rasyid (SP 116 05 0099)', 1, 25000, 5178000),
    (1, 1, '2024-08-02 15:26:00', '0001TL000002', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (SP 116 05 0099)', 0, 37000, 5141000),
    (1, 1, '2024-08-02 15:26:00', 'BASIL20210925', 'BASIL SEPTEMBER09/2021- Irvan Al Rasyid (SP 116 05 0099)', 1, 120000, 5261000),
    (1, 1, '2024-08-02 15:26:00', '0001TL000003', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (SP 116 05 0099)', 0, 45000, 5216000),
    (1, 1, '2024-08-02 15:26:00', '0001AO2000004', 'SETOR TUNAI - Irvan Al Rasyid (SP 116 05 0099)', 1, 60000, 5276000),
    (1, 1, '2024-08-02 15:26:00', '0001AO1000034', 'SETOR TUNAI - Irvan Al Rasyid (SP 116 05 0099)', 1, 8000, 5284000),
    (1, 1, '2024-08-02 15:26:00', '0001AO2000005', 'SETOR TUNAI - Irvan Al Rasyid (SP 116 05 0099)', 1, 12000, 5296000),
    (1, 1, '2024-08-02 15:26:00', '0001AO1000035', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (SP 116 05 0099)', 0, 90000, 5206000),
    (1, 1, '2024-08-02 15:26:00', '0001TL000004', 'SETOR TUNAI - Irvan Al Rasyid (SP 116 05 0099)', 1, 50000, 5256000),
    (1, 1, '2024-08-02 15:26:00', '0001AO2000006', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (SP 116 05 0099)', 0, 75000, 5181000),
    (1, 1, '2024-08-02 15:26:00', '0001AO1000036', 'SETOR TUNAI - Irvan Al Rasyid (SP 116 05 0099)', 1, 34000, 5215000),
    (1, 1, '2024-08-02 15:26:00', '0001AO2000007', 'SETOR TUNAI - Irvan Al Rasyid (SP 116 05 0099)', 1, 45000, 5260000),
    (1, 1, '2024-08-02 15:26:00', '0001TL000005', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (SP 116 05 0099)', 0, 54000, 5206000),
    (1, 1, '2024-08-02 15:26:00', '0001AO1000037', 'SETOR TUNAI - Irvan Al Rasyid (SP 116 05 0099)', 1, 16000, 5222000),
    (1, 1, '2024-08-02 15:26:00', '0001AO2000008', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (SP 116 05 0099)', 0, 47000, 5175000),
    (1, 1, '2024-08-02 15:26:00', '0001AO1000038', 'SETOR TUNAI - Irvan Al Rasyid (SP 116 05 0099)', 1, 29000, 5204000),

    (1, 1, '2024-08-03 15:26:00', '0001TL000002', 'SETOR TUNAI - Irvan Al Rasyid (SP 116 05 0099)', 1, 37000, 5000000),
    (1, 1, '2024-08-03 15:26:00', 'BASIL20210925', 'BASIL SEPTEMBER09/2021- Irvan Al Rasyid (SP 116 05 0099)', 1, 120000, 5120000),
    (1, 1, '2024-08-03 15:26:00', '0001AO1000033', 'SETOR TUNAI - Irvan Al Rasyid (SP 116 05 0099)', 1, 10000, 5130000),
    (1, 1, '2024-08-03 15:26:00', '0001AO2000003', 'SETOR TUNAI - Irvan Al Rasyid (SP 116 05 0099)', 1, 23000, 5153000),
    (1, 1, '2024-08-03 15:26:00', '0001AO1000032', 'SETOR TUNAI - Irvan Al Rasyid (SP 116 05 0099)', 1, 25000, 5178000),
    (1, 1, '2024-08-03 15:26:00', '0001TL000002', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (SP 116 05 0099)', 0, 37000, 5141000),
    (1, 1, '2024-08-03 15:26:00', 'BASIL20210925', 'BASIL SEPTEMBER09/2021- Irvan Al Rasyid (SP 116 05 0099)', 1, 120000, 5261000),
    (1, 1, '2024-08-03 15:26:00', '0001TL000003', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (SP 116 05 0099)', 0, 45000, 5216000),
    (1, 1, '2024-08-03 15:26:00', '0001AO2000004', 'SETOR TUNAI - Irvan Al Rasyid (SP 116 05 0099)', 1, 60000, 5276000),
    (1, 1, '2024-08-03 15:26:00', '0001AO1000034', 'SETOR TUNAI - Irvan Al Rasyid (SP 116 05 0099)', 1, 8000, 5284000),
    (1, 1, '2024-08-03 15:26:00', '0001AO2000005', 'SETOR TUNAI - Irvan Al Rasyid (SP 116 05 0099)', 1, 12000, 5296000),
    (1, 1, '2024-08-03 15:26:00', '0001AO1000035', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (SP 116 05 0099)', 0, 90000, 5206000),
    (1, 1, '2024-08-03 15:26:00', '0001TL000004', 'SETOR TUNAI - Irvan Al Rasyid (SP 116 05 0099)', 1, 50000, 5256000),
    (1, 1, '2024-08-03 15:26:00', '0001AO2000006', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (SP 116 05 0099)', 0, 75000, 5181000),
    (1, 1, '2024-08-03 15:26:00', '0001AO1000036', 'SETOR TUNAI - Irvan Al Rasyid (SP 116 05 0099)', 1, 34000, 5215000),
    (1, 1, '2024-08-03 15:26:00', '0001AO2000007', 'SETOR TUNAI - Irvan Al Rasyid (SP 116 05 0099)', 1, 45000, 5260000),
    (1, 1, '2024-08-03 15:26:00', '0001TL000005', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (SP 116 05 0099)', 0, 54000, 5206000),
    (1, 1, '2024-08-03 15:26:00', '0001AO1000037', 'SETOR TUNAI - Irvan Al Rasyid (SP 116 05 0099)', 1, 16000, 5222000),
    (1, 1, '2024-08-03 15:26:00', '0001AO2000008', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (SP 116 05 0099)', 0, 47000, 5175000),
    (1, 1, '2024-08-03 15:26:00', '0001AO1000038', 'SETOR TUNAI - Irvan Al Rasyid (SP 116 05 0099)', 1, 29000, 5204000),

    (1, 1, '2024-08-02 15:26:00', '0001TL000002', 'SETOR TUNAI - Irvan Al Rasyid (SW 116 06 0098)', 1, 37000, 6000000),
    (1, 1, '2024-08-02 15:26:00', 'BASIL20210925', 'BASIL SEPTEMBER09/2021- Irvan Al Rasyid (SW 116 06 0098)', 1, 120000, 6120000),
    (1, 1, '2024-08-02 15:26:00', '0001AO1000033', 'SETOR TUNAI - Irvan Al Rasyid (SW 116 06 0098)', 1, 10000, 6130000),
    (1, 1, '2024-08-02 15:26:00', '0001AO2000003', 'SETOR TUNAI - Irvan Al Rasyid (SW 116 06 0098)', 1, 23000, 6153000),
    (1, 1, '2024-08-02 15:26:00', '0001AO1000032', 'SETOR TUNAI - Irvan Al Rasyid (SW 116 06 0098)', 1, 25000, 6178000),
    (1, 1, '2024-08-02 15:26:00', '0001TL000002', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (SW 116 06 0098)', 0, 37000, 6141000),
    (1, 1, '2024-08-02 15:26:00', 'BASIL20210925', 'BASIL SEPTEMBER09/2021- Irvan Al Rasyid (SW 116 06 0098)', 1, 120000, 6261000),
    (1, 1, '2024-08-02 15:26:00', '0001TL000003', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (SW 116 06 0098)', 0, 45000, 6216000),
    (1, 1, '2024-08-02 15:26:00', '0001AO2000004', 'SETOR TUNAI - Irvan Al Rasyid (SW 116 06 0098)', 1, 60000, 6276000),
    (1, 1, '2024-08-02 15:26:00', '0001AO1000034', 'SETOR TUNAI - Irvan Al Rasyid (SW 116 06 0098)', 1, 8000, 6284000),
    (1, 1, '2024-08-02 15:26:00', '0001AO2000005', 'SETOR TUNAI - Irvan Al Rasyid (SW 116 06 0098)', 1, 12000, 6296000),
    (1, 1, '2024-08-02 15:26:00', '0001AO1000035', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (SW 116 06 0098)', 0, 90000, 6206000),
    (1, 1, '2024-08-02 15:26:00', '0001TL000004', 'SETOR TUNAI - Irvan Al Rasyid (SW 116 06 0098)', 1, 50000, 6256000),
    (1, 1, '2024-08-02 15:26:00', '0001AO2000006', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (SW 116 06 0098)', 0, 75000, 6181000),
    (1, 1, '2024-08-02 15:26:00', '0001AO1000036', 'SETOR TUNAI - Irvan Al Rasyid (SW 116 06 0098)', 1, 34000, 6215000),
    (1, 1, '2024-08-02 15:26:00', '0001AO2000007', 'SETOR TUNAI - Irvan Al Rasyid (SW 116 06 0098)', 1, 45000, 6260000),
    (1, 1, '2024-08-02 15:26:00', '0001TL000005', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (SW 116 06 0098)', 0, 54000, 6206000),
    (1, 1, '2024-08-02 15:26:00', '0001AO1000037', 'SETOR TUNAI - Irvan Al Rasyid (SW 116 06 0098)', 1, 16000, 6222000),
    (1, 1, '2024-08-02 15:26:00', '0001AO2000008', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (SW 116 06 0098)', 0, 47000, 6175000),
    (1, 1, '2024-08-02 15:26:00', '0001AO1000038', 'SETOR TUNAI - Irvan Al Rasyid (SW 116 06 0098)', 1, 29000, 6204000),
    (1, 1, '2024-08-02 15:26:00', '0001TL000006', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (SW 116 06 0098)', 0, 120000, 6084000),

    (1, 1, '2024-08-03 15:26:00', '0001TL000002', 'SETOR TUNAI - Irvan Al Rasyid (SW 116 06 0098)', 1, 37000, 6000000),
    (1, 1, '2024-08-03 15:26:00', 'BASIL20210925', 'BASIL SEPTEMBER09/2021- Irvan Al Rasyid (SW 116 06 0098)', 1, 120000, 6120000),
    (1, 1, '2024-08-03 15:26:00', '0001AO1000033', 'SETOR TUNAI - Irvan Al Rasyid (SW 116 06 0098)', 1, 10000, 6130000),
    (1, 1, '2024-08-03 15:26:00', '0001AO2000003', 'SETOR TUNAI - Irvan Al Rasyid (SW 116 06 0098)', 1, 23000, 6153000),
    (1, 1, '2024-08-03 15:26:00', '0001AO1000032', 'SETOR TUNAI - Irvan Al Rasyid (SW 116 06 0098)', 1, 25000, 6178000),
    (1, 1, '2024-08-03 15:26:00', '0001TL000002', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (SW 116 06 0098)', 0, 37000, 6141000),
    (1, 1, '2024-08-03 15:26:00', 'BASIL20210925', 'BASIL SEPTEMBER09/2021- Irvan Al Rasyid (SW 116 06 0098)', 1, 120000, 6261000),
    (1, 1, '2024-08-03 15:26:00', '0001TL000003', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (SW 116 06 0098)', 0, 45000, 6216000),
    (1, 1, '2024-08-03 15:26:00', '0001AO2000004', 'SETOR TUNAI - Irvan Al Rasyid (SW 116 06 0098)', 1, 60000, 6276000),
    (1, 1, '2024-08-03 15:26:00', '0001AO1000034', 'SETOR TUNAI - Irvan Al Rasyid (SW 116 06 0098)', 1, 8000, 6284000),
    (1, 1, '2024-08-03 15:26:00', '0001AO2000005', 'SETOR TUNAI - Irvan Al Rasyid (SW 116 06 0098)', 1, 12000, 6296000),
    (1, 1, '2024-08-03 15:26:00', '0001AO1000035', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (SW 116 06 0098)', 0, 90000, 6206000),
    (1, 1, '2024-08-03 15:26:00', '0001TL000004', 'SETOR TUNAI - Irvan Al Rasyid (SW 116 06 0098)', 1, 50000, 6256000),
    (1, 1, '2024-08-03 15:26:00', '0001AO2000006', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (SW 116 06 0098)', 0, 75000, 6181000),
    (1, 1, '2024-08-03 15:26:00', '0001AO1000036', 'SETOR TUNAI - Irvan Al Rasyid (SW 116 06 0098)', 1, 34000, 6215000),
    (1, 1, '2024-08-03 15:26:00', '0001AO2000007', 'SETOR TUNAI - Irvan Al Rasyid (SW 116 06 0098)', 1, 45000, 6260000),
    (1, 1, '2024-08-03 15:26:00', '0001TL000005', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (SW 116 06 0098)', 0, 54000, 6206000),
    (1, 1, '2024-08-03 15:26:00', '0001AO1000037', 'SETOR TUNAI - Irvan Al Rasyid (SW 116 06 0098)', 1, 16000, 6222000),
    (1, 1, '2024-08-03 15:26:00', '0001AO2000008', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (SW 116 06 0098)', 0, 47000, 6175000),
    (1, 1, '2024-08-03 15:26:00', '0001AO1000038', 'SETOR TUNAI - Irvan Al Rasyid (SW 116 06 0098)', 1, 29000, 6204000),
    (1, 1, '2024-08-03 15:26:00', '0001TL000006', 'TRF KE Bagas Jumadi - Irvan Al Rasyid (SW 116 06 0098)', 0, 120000, 6084000),


    (2, 1, '2024-08-02 15:26:00', '0001AO1000033', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (116 14 5063)', 0, 150000, 4361596),
    (2, 1, '2024-08-02 15:26:00', 'BASIL20210925', 'BASIL SEPTEMBER09/2021- Bagas Jumadi (116 14 5063)', 1, 120000, 4511596),
    (2, 1, '2024-08-02 15:26:00', '0001TL000002', 'SETOR TUNAI - Bagas Jumadi (116 14 5063)', 1, 37000, 4391596),
    (2, 1, '2024-08-02 15:26:00', '0001AO1000032', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (116 14 5063)', 0, 25000, 4354596),
    (2, 1, '2024-08-02 15:26:00', '0001AO2000003', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (116 14 5063)', 0, 23000, 4379596),
    (2, 1, '2024-08-02 15:26:00', '0001AO1000033', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (116 14 5063)', 0, 10000, 4402596),
    (2, 1, '2024-08-02 15:26:00', 'BASIL20210925', 'BASIL SEPTEMBER09/2021- Bagas Jumadi (116 14 5063)', 1, 120000, 4412596),
    (2, 1, '2024-08-02 15:26:00', '0001TL000002', 'SETOR TUNAI - Bagas Jumadi (116 14 5063)', 1, 37000, 4292596),
    (2, 1, '2024-08-02 15:26:00', '0001AO1000032', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (116 14 5063)', 0, 25000, 4255596),
    (2, 1, '2024-08-02 15:26:00', '0001AO2000003', 'SETOR TUNAI - Bagas Jumadi (116 14 5063)', 1, 23000, 4280596),
    (2, 1, '2024-08-02 15:26:00', '0001AO1000033', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (116 14 5063)', 0, 150000, 4257596),
    (2, 1, '2024-08-02 15:26:00', 'BASIL20210925', 'BASIL SEPTEMBER09/2021- Bagas Jumadi (116 14 5063)', 1, 120000, 4407596),
    (2, 1, '2024-08-02 15:26:00', '0001TL000002', 'SETOR TUNAI - Bagas Jumadi (116 14 5063)', 1, 37000, 4287596),
    (2, 1, '2024-08-02 15:26:00', '0001AO1000032', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (116 14 5063)', 0, 25000, 4250596),
    (2, 1, '2024-08-02 15:26:00', '0001AO2000003', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (116 14 5063)', 0, 23000, 4275596),
    (2, 1, '2024-08-02 15:26:00', '0001AO1000033', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (116 14 5063)', 0, 10000, 4298596),
    (2, 1, '2024-08-02 15:26:00', 'BASIL20210925', 'BASIL SEPTEMBER09/2021- Bagas Jumadi (116 14 5063)', 1, 120000, 4308596),
    (2, 1, '2024-08-02 15:26:00', '0001TL000002', 'SETOR TUNAI - Bagas Jumadi (116 14 5063)', 1, 37000, 4188596),
    (2, 1, '2024-08-02 15:26:00', '0001AO1000032', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (116 14 5063)', 0, 25000, 4151596),
    (2, 1, '2024-08-02 15:26:00', '0001AO2000003', 'SETOR TUNAI - Bagas Jumadi (116 14 5063)', 1, 23000, 4209596),

    (2, 1, '2024-08-03 15:26:00', '0001AO1000033', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (116 14 5063)', 0, 150000, 4361596),
    (2, 1, '2024-08-03 15:26:00', 'BASIL20210925', 'BASIL SEPTEMBER09/2021- Bagas Jumadi (116 14 5063)', 1, 120000, 4511596),
    (2, 1, '2024-08-03 15:26:00', '0001TL000002', 'SETOR TUNAI - Bagas Jumadi (116 14 5063)', 1, 37000, 4391596),
    (2, 1, '2024-08-03 15:26:00', '0001AO1000032', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (116 14 5063)', 0, 25000, 4354596),
    (2, 1, '2024-08-03 15:26:00', '0001AO2000003', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (116 14 5063)', 0, 23000, 4379596),
    (2, 1, '2024-08-03 15:26:00', '0001AO1000033', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (116 14 5063)', 0, 10000, 4402596),
    (2, 1, '2024-08-03 15:26:00', 'BASIL20210925', 'BASIL SEPTEMBER09/2021- Bagas Jumadi (116 14 5063)', 1, 120000, 4412596),
    (2, 1, '2024-08-03 15:26:00', '0001TL000002', 'SETOR TUNAI - Bagas Jumadi (116 14 5063)', 1, 37000, 4292596),
    (2, 1, '2024-08-03 15:26:00', '0001AO1000032', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (116 14 5063)', 0, 25000, 4255596),
    (2, 1, '2024-08-03 15:26:00', '0001AO2000003', 'SETOR TUNAI - Bagas Jumadi (116 14 5063)', 1, 23000, 4280596),
    (2, 1, '2024-08-03 15:26:00', '0001AO1000033', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (116 14 5063)', 0, 150000, 4257596),
    (2, 1, '2024-08-03 15:26:00', 'BASIL20210925', 'BASIL SEPTEMBER09/2021- Bagas Jumadi (116 14 5063)', 1, 120000, 4407596),
    (2, 1, '2024-08-03 15:26:00', '0001TL000002', 'SETOR TUNAI - Bagas Jumadi (116 14 5063)', 1, 37000, 4287596),
    (2, 1, '2024-08-03 15:26:00', '0001AO1000032', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (116 14 5063)', 0, 25000, 4250596),
    (2, 1, '2024-08-03 15:26:00', '0001AO2000003', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (116 14 5063)', 0, 23000, 4275596),
    (2, 1, '2024-08-03 15:26:00', '0001AO1000033', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (116 14 5063)', 0, 10000, 4298596),
    (2, 1, '2024-08-03 15:26:00', 'BASIL20210925', 'BASIL SEPTEMBER09/2021- Bagas Jumadi (116 14 5063)', 1, 120000, 4308596),
    (2, 1, '2024-08-03 15:26:00', '0001TL000002', 'SETOR TUNAI - Bagas Jumadi (116 14 5063)', 1, 37000, 4188596),
    (2, 1, '2024-08-03 15:26:00', '0001AO1000032', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (116 14 5063)', 0, 25000, 4151596),
    (2, 1, '2024-08-03 15:26:00', '0001AO2000003', 'SETOR TUNAI - Bagas Jumadi (116 14 5063)', 1, 23000, 4209596),

    (2, 1, '2024-08-02 15:26:00', '0001TL000002', 'SETOR TUNAI - Bagas Jumadi (SP 116 15 0099)', 1, 37000, 5000000),
    (2, 1, '2024-08-02 15:26:00', 'BASIL20210925', 'BASIL SEPTEMBER09/2021- Bagas Jumadi (SP 116 15 0099)', 1, 120000, 5120000),
    (2, 1, '2024-08-02 15:26:00', '0001AO1000033', 'SETOR TUNAI - Bagas Jumadi (SP 116 15 0099)', 1, 10000, 5130000),
    (2, 1, '2024-08-02 15:26:00', '0001AO2000003', 'SETOR TUNAI - Bagas Jumadi (SP 116 15 0099)', 1, 23000, 5153000),
    (2, 1, '2024-08-02 15:26:00', '0001AO1000032', 'SETOR TUNAI - Bagas Jumadi (SP 116 15 0099)', 1, 25000, 5178000),
    (2, 1, '2024-08-02 15:26:00', '0001TL000002', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (SP 116 15 0099)', 0, 37000, 5141000),
    (2, 1, '2024-08-02 15:26:00', 'BASIL20210925', 'BASIL SEPTEMBER09/2021- Bagas Jumadi (SP 116 15 0099)', 1, 120000, 5261000),
    (2, 1, '2024-08-02 15:26:00', '0001TL000003', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (SP 116 15 0099)', 0, 45000, 5216000),
    (2, 1, '2024-08-02 15:26:00', '0001AO2000004', 'SETOR TUNAI - Bagas Jumadi (SP 116 15 0099)', 1, 60000, 5276000),
    (2, 1, '2024-08-02 15:26:00', '0001AO1000034', 'SETOR TUNAI - Bagas Jumadi (SP 116 15 0099)', 1, 8000, 5284000),
    (2, 1, '2024-08-02 15:26:00', '0001AO2000005', 'SETOR TUNAI - Bagas Jumadi (SP 116 15 0099)', 1, 12000, 5296000),
    (2, 1, '2024-08-02 15:26:00', '0001AO1000035', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (SP 116 15 0099)', 0, 90000, 5206000),
    (2, 1, '2024-08-02 15:26:00', '0001TL000004', 'SETOR TUNAI - Bagas Jumadi (SP 116 15 0099)', 1, 50000, 5256000),
    (2, 1, '2024-08-02 15:26:00', '0001AO2000006', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (SP 116 15 0099)', 0, 75000, 5181000),
    (2, 1, '2024-08-02 15:26:00', '0001AO1000036', 'SETOR TUNAI - Bagas Jumadi (SP 116 15 0099)', 1, 34000, 5215000),
    (2, 1, '2024-08-02 15:26:00', '0001AO2000007', 'SETOR TUNAI - Bagas Jumadi (SP 116 15 0099)', 1, 45000, 5260000),
    (2, 1, '2024-08-02 15:26:00', '0001TL000005', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (SP 116 15 0099)', 0, 54000, 5206000),
    (2, 1, '2024-08-02 15:26:00', '0001AO1000037', 'SETOR TUNAI - Bagas Jumadi (SP 116 15 0099)', 1, 16000, 5222000),
    (2, 1, '2024-08-02 15:26:00', '0001AO2000008', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (SP 116 15 0099)', 0, 47000, 5175000),
    (2, 1, '2024-08-02 15:26:00', '0001AO1000038', 'SETOR TUNAI - Bagas Jumadi (SP 116 15 0099)', 1, 29000, 5204000),

    (2, 1, '2024-08-03 15:26:00', '0001TL000002', 'SETOR TUNAI - Bagas Jumadi (SP 116 15 0099)', 1, 37000, 5000000),
    (2, 1, '2024-08-03 15:26:00', 'BASIL20210925', 'BASIL SEPTEMBER09/2021- Bagas Jumadi (SP 116 15 0099)', 1, 120000, 5120000),
    (2, 1, '2024-08-03 15:26:00', '0001AO1000033', 'SETOR TUNAI - Bagas Jumadi (SP 116 15 0099)', 1, 10000, 5130000),
    (2, 1, '2024-08-03 15:26:00', '0001AO2000003', 'SETOR TUNAI - Bagas Jumadi (SP 116 15 0099)', 1, 23000, 5153000),
    (2, 1, '2024-08-03 15:26:00', '0001AO1000032', 'SETOR TUNAI - Bagas Jumadi (SP 116 15 0099)', 1, 25000, 5178000),
    (2, 1, '2024-08-03 15:26:00', '0001TL000002', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (SP 116 15 0099)', 0, 37000, 5141000),
    (2, 1, '2024-08-03 15:26:00', 'BASIL20210925', 'BASIL SEPTEMBER09/2021- Bagas Jumadi (SP 116 15 0099)', 1, 120000, 5261000),
    (2, 1, '2024-08-03 15:26:00', '0001TL000003', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (SP 116 15 0099)', 0, 45000, 5216000),
    (2, 1, '2024-08-03 15:26:00', '0001AO2000004', 'SETOR TUNAI - Bagas Jumadi (SP 116 15 0099)', 1, 60000, 5276000),
    (2, 1, '2024-08-03 15:26:00', '0001AO1000034', 'SETOR TUNAI - Bagas Jumadi (SP 116 15 0099)', 1, 8000, 5284000),
    (2, 1, '2024-08-03 15:26:00', '0001AO2000005', 'SETOR TUNAI - Bagas Jumadi (SP 116 15 0099)', 1, 12000, 5296000),
    (2, 1, '2024-08-03 15:26:00', '0001AO1000035', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (SP 116 15 0099)', 0, 90000, 5206000),
    (2, 1, '2024-08-03 15:26:00', '0001TL000004', 'SETOR TUNAI - Bagas Jumadi (SP 116 15 0099)', 1, 50000, 5256000),
    (2, 1, '2024-08-03 15:26:00', '0001AO2000006', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (SP 116 15 0099)', 0, 75000, 5181000),
    (2, 1, '2024-08-03 15:26:00', '0001AO1000036', 'SETOR TUNAI - Bagas Jumadi (SP 116 15 0099)', 1, 34000, 5215000),
    (2, 1, '2024-08-03 15:26:00', '0001AO2000007', 'SETOR TUNAI - Bagas Jumadi (SP 116 15 0099)', 1, 45000, 5260000),
    (2, 1, '2024-08-03 15:26:00', '0001TL000005', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (SP 116 15 0099)', 0, 54000, 5206000),
    (2, 1, '2024-08-03 15:26:00', '0001AO1000037', 'SETOR TUNAI - Bagas Jumadi (SP 116 15 0099)', 1, 16000, 5222000),
    (2, 1, '2024-08-03 15:26:00', '0001AO2000008', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (SP 116 15 0099)', 0, 47000, 5175000),
    (2, 1, '2024-08-03 15:26:00', '0001AO1000038', 'SETOR TUNAI - Bagas Jumadi (SP 116 15 0099)', 1, 29000, 5204000),

    (2, 1, '2024-08-02 15:26:00', '0001TL000002', 'SETOR TUNAI - Bagas Jumadi (SW 116 16 0098)', 1, 37000, 6000000),
    (2, 1, '2024-08-02 15:26:00', 'BASIL20210925', 'BASIL SEPTEMBER09/2021- Bagas Jumadi (SW 116 16 0098)', 1, 120000, 6120000),
    (2, 1, '2024-08-02 15:26:00', '0001AO1000033', 'SETOR TUNAI - Bagas Jumadi (SW 116 16 0098)', 1, 10000, 6130000),
    (2, 1, '2024-08-02 15:26:00', '0001AO2000003', 'SETOR TUNAI - Bagas Jumadi (SW 116 16 0098)', 1, 23000, 6153000),
    (2, 1, '2024-08-02 15:26:00', '0001AO1000032', 'SETOR TUNAI - Bagas Jumadi (SW 116 16 0098)', 1, 25000, 6178000),
    (2, 1, '2024-08-02 15:26:00', '0001TL000002', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (SW 116 16 0098)', 0, 37000, 6141000),
    (2, 1, '2024-08-02 15:26:00', 'BASIL20210925', 'BASIL SEPTEMBER09/2021- Bagas Jumadi (SW 116 16 0098)', 1, 120000, 6261000),
    (2, 1, '2024-08-02 15:26:00', '0001TL000003', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (SW 116 16 0098)', 0, 45000, 6216000),
    (2, 1, '2024-08-02 15:26:00', '0001AO2000004', 'SETOR TUNAI - Bagas Jumadi (SW 116 16 0098)', 1, 60000, 6276000),
    (2, 1, '2024-08-02 15:26:00', '0001AO1000034', 'SETOR TUNAI - Bagas Jumadi (SW 116 16 0098)', 1, 8000, 6284000),
    (2, 1, '2024-08-02 15:26:00', '0001AO2000005', 'SETOR TUNAI - Bagas Jumadi (SW 116 16 0098)', 1, 12000, 6296000),
    (2, 1, '2024-08-02 15:26:00', '0001AO1000035', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (SW 116 16 0098)', 0, 90000, 6206000),
    (2, 1, '2024-08-02 15:26:00', '0001TL000004', 'SETOR TUNAI - Bagas Jumadi (SW 116 16 0098)', 1, 50000, 6256000),
    (2, 1, '2024-08-02 15:26:00', '0001AO2000006', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (SW 116 16 0098)', 0, 75000, 6181000),
    (2, 1, '2024-08-02 15:26:00', '0001AO1000036', 'SETOR TUNAI - Bagas Jumadi (SW 116 16 0098)', 1, 34000, 6215000),
    (2, 1, '2024-08-02 15:26:00', '0001AO2000007', 'SETOR TUNAI - Bagas Jumadi (SW 116 16 0098)', 1, 45000, 6260000),
    (2, 1, '2024-08-02 15:26:00', '0001TL000005', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (SW 116 16 0098)', 0, 54000, 6206000),
    (2, 1, '2024-08-02 15:26:00', '0001AO1000037', 'SETOR TUNAI - Bagas Jumadi (SW 116 16 0098)', 1, 16000, 6222000),
    (2, 1, '2024-08-02 15:26:00', '0001AO2000008', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (SW 116 16 0098)', 0, 47000, 6175000),
    (2, 1, '2024-08-02 15:26:00', '0001AO1000038', 'SETOR TUNAI - Bagas Jumadi (SW 116 16 0098)', 1, 29000, 6204000),
    (2, 1, '2024-08-02 15:26:00', '0001TL000006', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (SW 116 16 0098)', 0, 120000, 6084000),

    (2, 1, '2024-08-03 15:26:00', '0001TL000002', 'SETOR TUNAI - Bagas Jumadi (SW 116 16 0098)', 1, 37000, 6000000),
    (2, 1, '2024-08-03 15:26:00', 'BASIL20210925', 'BASIL SEPTEMBER09/2021- Bagas Jumadi (SW 116 16 0098)', 1, 120000, 6120000),
    (2, 1, '2024-08-03 15:26:00', '0001AO1000033', 'SETOR TUNAI - Bagas Jumadi (SW 116 16 0098)', 1, 10000, 6130000),
    (2, 1, '2024-08-03 15:26:00', '0001AO2000003', 'SETOR TUNAI - Bagas Jumadi (SW 116 16 0098)', 1, 23000, 6153000),
    (2, 1, '2024-08-03 15:26:00', '0001AO1000032', 'SETOR TUNAI - Bagas Jumadi (SW 116 16 0098)', 1, 25000, 6178000),
    (2, 1, '2024-08-03 15:26:00', '0001TL000002', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (SW 116 16 0098)', 0, 37000, 6141000),
    (2, 1, '2024-08-03 15:26:00', 'BASIL20210925', 'BASIL SEPTEMBER09/2021- Bagas Jumadi (SW 116 16 0098)', 1, 120000, 6261000),
    (2, 1, '2024-08-03 15:26:00', '0001TL000003', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (SW 116 16 0098)', 0, 45000, 6216000),
    (2, 1, '2024-08-03 15:26:00', '0001AO2000004', 'SETOR TUNAI - Bagas Jumadi (SW 116 16 0098)', 1, 60000, 6276000),
    (2, 1, '2024-08-03 15:26:00', '0001AO1000034', 'SETOR TUNAI - Bagas Jumadi (SW 116 16 0098)', 1, 8000, 6284000),
    (2, 1, '2024-08-03 15:26:00', '0001AO2000005', 'SETOR TUNAI - Bagas Jumadi (SW 116 16 0098)', 1, 12000, 6296000),
    (2, 1, '2024-08-03 15:26:00', '0001AO1000035', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (SW 116 16 0098)', 0, 90000, 6206000),
    (2, 1, '2024-08-03 15:26:00', '0001TL000004', 'SETOR TUNAI - Bagas Jumadi (SW 116 16 0098)', 1, 50000, 6256000),
    (2, 1, '2024-08-03 15:26:00', '0001AO2000006', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (SW 116 16 0098)', 0, 75000, 6181000),
    (2, 1, '2024-08-03 15:26:00', '0001AO1000036', 'SETOR TUNAI - Bagas Jumadi (SW 116 16 0098)', 1, 34000, 6215000),
    (2, 1, '2024-08-03 15:26:00', '0001AO2000007', 'SETOR TUNAI - Bagas Jumadi (SW 116 16 0098)', 1, 45000, 6260000),
    (2, 1, '2024-08-03 15:26:00', '0001TL000005', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (SW 116 16 0098)', 0, 54000, 6206000),
    (2, 1, '2024-08-03 15:26:00', '0001AO1000037', 'SETOR TUNAI - Bagas Jumadi (SW 116 16 0098)', 1, 16000, 6222000),
    (2, 1, '2024-08-03 15:26:00', '0001AO2000008', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (SW 116 16 0098)', 0, 47000, 6175000),
    (2, 1, '2024-08-03 15:26:00', '0001AO1000038', 'SETOR TUNAI - Bagas Jumadi (SW 116 16 0098)', 1, 29000, 6204000),
    (2, 1, '2024-08-03 15:26:00', '0001TL000006', 'TRF KE Irvan Al Rasyid - Bagas Jumadi (SW 116 16 0098)', 0, 120000, 6084000);

-- Menyisipkan data ke table informasi_rekening_simpanan
INSERT INTO informasi_rekening_simpanan (user_id, token_id, name, company_code, company, branch_code, branch, code, timestamp_registration, product_name, product_scheme)
VALUES (1, 1, 'Irvan Al Rasyid', '988', 'KOPERASI SYARIAH DEMO', '00', 'PUSAT', '116 04 5063', '2016-04-21', 'TABUNGAN SIMPATI', 'WADIAH'),
       (1, 1, 'Irvan Al Rasyid', '877', 'KOPERASI DEMO', '11', 'PUSAT', 'SP 116 05 0099', '2016-05-21', 'SIMPANAN POKOK', 'WADIAH'),
       (1, 1, 'Irvan Al Rasyid', '766', 'SYARIAH DEMO', '22', 'PUSAT', 'SW 116 06 0098', '2016-05-21', 'SIMPANAN WAJIB', 'WADIAH'),
       (2, 1, 'Bagas Jumadi', '987', 'KOPERASI SYARIAH DEMO', '00', 'PUSAT', '116 14 5063', '2016-04-21', 'TABUNGAN SIMPATI', 'WADIAH'),
       (2, 1, 'Bagas Jumadi', '876', 'KOPERASI DEMO', '12', 'PUSAT', 'SP 116 15 0099', '2016-05-21', 'SIMPANAN POKOK', 'WADIAH'),
       (2, 1, 'Bagas Jumadi', '765', 'SYARIAH DEMO', '23', 'PUSAT', 'SW 116 16 0098', '2016-05-21', 'SIMPANAN WAJIB', 'WADIAH');
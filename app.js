const express = require('express');
const tokenRoutes = require('./routes/tokenRoutes');
const credentialLoginRoutes = require('./routes/credentialLoginRoutes');
const credentialLogoutRoutes = require('./routes/credentialLogoutRoutes');
const credentialChangePasswordRoutes = require('./routes/credentialChangePasswordRoutes');
const informationUsers = require('./routes/informationUsersRoutes');
const rekeningUtamaUsers = require('./routes/rekeningUtamaUsersRoutes');
const listTabunganSimpananUsers = require('./routes/listTabunganSimpananUsersRoutes');
const listRekeningDepositoSimpananBerjangka = require('./routes/listRekeningDepositoSimpananBerjangkaRoutes');
const listRekeningPembiayaan = require('./routes/listRekeningPembiayaanRoutes');
const list5transaksi = require('./routes/list5transaksiRoutes');
const list10transaksi = require('./routes/list10transaksiRoutes');
const list20transaksi = require('./routes/list20transaksiRoutes');
const list5transaksiByDate = require('./routes/list5transaksiByDateRoutes');
const list10transaksiByDate = require('./routes/list10transaksiByDateRoutes');
const list20transaksiByDate = require('./routes/list20transaksiByDateRoutes');
const informasiRekeningSimpanan = require('./routes/informasiRekeningSimpananRoutes');

const app = express();

require('dotenv').config();

app.use(express.json());
app.use(express.static('public'));

// Gunakan rute
app.use(tokenRoutes);
app.use(credentialLoginRoutes);
app.use(credentialLogoutRoutes);
app.use(credentialChangePasswordRoutes);
app.use(informationUsers);
app.use(rekeningUtamaUsers);
app.use(listTabunganSimpananUsers);
app.use(listRekeningDepositoSimpananBerjangka);
app.use(listRekeningPembiayaan);
app.use(list5transaksi);
app.use(list10transaksi);
app.use(list20transaksi);
app.use(list5transaksiByDate);
app.use(list10transaksiByDate);
app.use(list20transaksiByDate);
app.use(informasiRekeningSimpanan);

// Middleware untuk menangani permintaan ke endpoint selain /login
const handleNotFound = (req, res, next) => {
  res.status(404).send('404 NOT FOUND !!!');
};

app.use(handleNotFound);

// Menjalankan Port http express
const PORT = process.env.PORT || 3000;
app.listen(PORT,'0.0.0.0', () => {
  console.log(`Server berjalan pada port ${PORT}`);
});

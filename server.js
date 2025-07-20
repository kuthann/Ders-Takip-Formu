const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const bcrypt = require('bcrypt');

const app = express();
const PORT = 3001;

app.use(cors());
app.use(bodyParser.json());

// Basit kullanıcı listesi
const users = [
  {
    username: 'k1',
    passwordHash: bcrypt.hashSync('k2', 10),
    name: 'Oğlum',
  }
];

// Giriş endpoint'i
app.post('/api/login', async (req, res) => {
  const { username, password } = req.body;
  const user = users.find(u => u.username === username);
  if (!user) {
    return res.status(401).json({ message: 'Kullanıcı adı veya şifre hatalı.' });
  }
  const valid = await bcrypt.compare(password, user.passwordHash);
  if (!valid) {
    return res.status(401).json({ message: 'Kullanıcı adı veya şifre hatalı.' });
  }
  res.json({ message: 'Giriş başarılı', username: user.username, name: user.name });
});

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
}); 

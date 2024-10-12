const express = require('express');
const mysql2 = require('mysql2/promise');
const path = require('path');
const bodyParser = require('body-parser');
const mysql = require('mysql');
const multer = require('multer');
const app = express();
const port = 3001;


// ตั้งค่า body-parser เพื่อรับข้อมูลจากฟอร์ม
app.use(bodyParser.urlencoded({ extended: true }));

// ตั้งค่า EJS เป็น view engine สำหรับการ render หน้าเว็บ
app.set('view engine', 'ejs');

app.use(express.static("public"));

// ตั้งค่าการใช้งาน static files จากโฟลเดอร์ public
app.use(express.static(path.join(__dirname, 'public')));

// Middleware สำหรับแปลงข้อมูลจากฟอร์ม HTML
app.use(express.urlencoded({ extended: true }));

// Middleware สำหรับแปลงข้อมูล JSON
app.use(express.json());

// ตั้งค่า Multer สำหรับการอัปโหลดไฟล์
const storage = multer.diskStorage({
  destination: './uploads',
  filename: (req, file, cb) => {
      cb(null, Date.now() + path.extname(file.originalname));
  }
});
const upload = multer({ storage: storage });

// ตั้งค่าการเชื่อมต่อฐานข้อมูล MySQL
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'mydb'
});

db.connect(err => {
    if (err) throw err;
    console.log('Connected to MySQL Database');
});

// Route แสดงฟอร์ม
app.use(express.static(__dirname)); // เสิร์ฟไฟล์ static เช่น HTML, CSS

// กำหนดเส้นทางสำหรับแสดงไฟล์ Static
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// Route สำหรับบันทึกข้อมูลจากฟอร์ม
app.post('/tickets', upload.single('screenshot'), (req, res) => {
    const { userID, date, phone, category, description } = req.body;
    const screenshotPath = req.file ? `/uploads/${req.file.filename}` : null;

    const sql = 'INSERT INTO tickets (userID, date, phone, category, description, screenshot_path) VALUES (?, ?, ?, ?, ?, ?)';
    const values = [userID, date, phone, category, description, screenshotPath];

    db.query(sql, values, (err, result) => {
        if (err) throw err;
        console.log('Ticket saved:', result);
        res.send('บันทึกข้อมูลเรียบร้อยแล้ว!');
    });
});


/* 
สร้าง connection pool สำหรับ MySQL
- ใช้ค่าจาก environment variables ถ้ามี ไม่เช่นนั้นใช้ค่าเริ่มต้น
- waitForConnections: รอการเชื่อมต่อถ้า pool เต็ม
- connectionLimit: จำนวนการเชื่อมต่อสูงสุดที่อนุญาต
- queueLimit: จำนวนคำขอในคิวสูงสุด (0 หมายถึงไม่จำกัด)
*/
const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'user',
  password: process.env.DB_PASSWORD || 'password',
  database: process.env.DB_NAME || 'myapp',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

app.get('/', (req, res) => {
  res.render('login');
});

app.get("/home", (req, res) => {
  res.render('home'); 
});

app.get("/register", (req , res) => {
  res.render('register');
})

app.post('/register', (req, res) => {
  res.render('login');
})

// จัดการข้อมูลฟอร์มล็อกอิน (POST)
app.post('/login', (req, res) => {
  const { email, password } = req.body;

  // ตัวอย่างการตรวจสอบผู้ใช้ (จำลอง)
  if (email === 'atiwitpat46@gmail.com' && password === '12345') {
    res.redirect('/home');
  } else {
    res.render('login', { message: 'อีเมลหรือรหัสผ่านไม่ถูกต้อง' });
  }
});

// เส้นทางหลัก (root route) - แสดงหน้ารายชื่อผู้ใช้พร้อมฟังก์ชันค้นหา
app.get('/users', async (req, res) => {
  try {
    let query = 'SELECT * FROM users';
    let queryParams = [];
    
    // ตรวจสอบว่ามีการส่งพารามิเตอร์ search มาหรือไม่
    if (req.query.search) {
      query += ' WHERE name LIKE ?';
      queryParams.push(`%${req.query.search}%`);
    }

    // เพิ่ม ORDER BY เพื่อเรียงลำดับผลลัพธ์
    query += ' ORDER BY name ASC';

    const [rows] = await pool.query(query, queryParams);
    
    // ส่งข้อมูลไปยังหน้า EJS เพื่อแสดงผล พร้อมกับค่า search ที่ใช้ค้นหา (ถ้ามี)
    res.render('/users', { users: rows, search: req.query.search || '' });
  } catch (error) {
    console.error(error);
    res.status(500).send('Internal Server Error');
  }
});

// เส้นทางไปยังหน้าเพิ่มผู้ใช้
app.get('/add-user', (req, res) => {
  // แสดงหน้าเพิ่มผู้ใช้
  res.render('add-user');
});

// จัดการการส่งฟอร์มเพิ่มผู้ใช้
app.post('/add-user', async (req, res) => {
  // ดึงข้อมูลชื่อและอีเมลจากฟอร์มที่ส่งมา
  const { name, email } = req.body;
  try {
    // เพิ่มข้อมูลผู้ใช้ใหม่ลงในฐานข้อมูล
    await pool.query('INSERT INTO users (name, email) VALUES (?, ?)', [name, email]);
    // เปลี่ยนเส้นทางกลับไปยังหน้าหลัก
    res.redirect('/');
  } catch (error) {
    console.error(error);
    res.status(500).send('Internal Server Error');
  }
});

// เส้นทางไปยังหน้าแก้ไขข้อมูลผู้ใช้
app.get('/users/:id/edit', async (req, res) => {
  // ดึง ID ของผู้ใช้จาก URL parameters
  const { id } = req.params;
  try {
    // ดึงข้อมูลผู้ใช้ที่ต้องการแก้ไขจากฐานข้อมูล
    const [rows] = await pool.query('SELECT * FROM users WHERE id = ?', [id]);
    if (rows.length > 0) {
      // ถ้าพบข้อมูลผู้ใช้ ให้แสดงหน้าแก้ไขพร้อมข้อมูล
      res.render('edit-user', { user: rows[0] });
    } else {
      // ถ้าไม่พบข้อมูลผู้ใช้ ให้แสดงข้อความแจ้งเตือน
      res.status(404).send('User not found');
    }
  } catch (error) {
    console.error(error);
    res.status(500).send('Internal Server Error');
  }
});

app.get('/tickets',(req, res) => {
  res.render('helpdesktable');
});
// สร้าง ticket
app.get('/tickets/new', (req, res) => {
  res.render('helpdesk');
});

//report
app.post('/tickets', (req, res) => {
  res.render('helpdesktable')
});

// จัดการการอัปเดตข้อมูลผู้ใช้ด้วยวิธี PUT
app.put('/users/:id', async (req, res) => {
  // ดึง ID ของผู้ใช้จาก URL parameters และข้อมูลใหม่จาก request body
  const { id } = req.params;
  const { name, email } = req.body;

  // แสดงข้อมูลที่ได้รับจาก request ใน console เพื่อการตรวจสอบ
  console.log('Received data:', { id, name, email });

  try {
    // ตรวจสอบว่ามีข้อมูลที่จำเป็นครบถ้วนหรือไม่
    if (!name || !email) {
      console.log('Missing required fields');
      return res.status(400).json({ error: 'Name and email are required' });
    }

    // อัปเดตข้อมูลผู้ใช้ในฐานข้อมูล
    const [result] = await pool.query('UPDATE users SET name = ?, email = ? WHERE id = ?', [name, email, id]);
    
    // แสดงผลลัพธ์จากการ query ใน console เพื่อการตรวจสอบ
    console.log('Query result:', result);

    if (result.affectedRows > 0) {
      // ถ้ามีการอัปเดตข้อมูลสำเร็จ
      res.status(200).json({ message: 'User updated successfully' });
    } else {
      // ถ้าไม่พบข้อมูลผู้ใช้ที่ต้องการอัปเดต
      res.status(404).json({ error: 'User not found' });
    }
  } catch (error) {
    console.error('Error updating user:', error);
    res.status(500).json({ error: 'Internal Server Error', details: error.message });
  }
});

// จัดการการลบข้อมูลผู้ใช้ด้วยวิธี DELETE
app.delete('/users/:id', async (req, res) => {
  // ดึง ID ของผู้ใช้จาก URL parameters
  const { id } = req.params;
  try {
    // ลบข้อมูลผู้ใช้จากฐานข้อมูล
    await pool.query('DELETE FROM users WHERE id = ?', [id]);
    res.status(200).json({ message: 'User deleted successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// ตัวจัดการข้อผิดพลาดแบบ global
app.use((err, req, res, next) => {
  // แสดงข้อผิดพลาดใน console
  console.error(err.stack);
  // ส่งข้อความแจ้งเตือนข้อผิดพลาดกลับไปยังผู้ใช้
  res.status(500).json({ error: 'Something went wrong!', details: err.message });
});

app.get('/contact', (req, res) => {
  res.render('contact');
})

// เริ่มการทำงานของเซิร์ฟเวอร์
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
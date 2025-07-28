# دليل نشر الباك إند على Vercel

## الخطوات:

### 1. تثبيت Vercel CLI
```bash
npm install -g vercel
```

### 2. تسجيل الدخول إلى Vercel
```bash
vercel login
```

### 3. نشر المشروع
```bash
vercel --prod
```

### 4. أو يمكنك رفع المشروع يدوياً:
- اذهب إلى [vercel.com](https://vercel.com)
- سجل دخول أو أنشئ حساب جديد
- اضغط على "New Project"
- ارفع مجلد `paypass-backend-main`
- اضغط على "Deploy"

## ملاحظات مهمة:

### ملف vercel.json
- تم تكوينه بالفعل ليعمل مع Node.js
- جميع routes تبدأ بـ `/api` ستوجه إلى `index.js`

### متغيرات البيئة
- أضف متغيرات البيئة في إعدادات المشروع على Vercel
- أو أنشئ ملف `.env` محلياً

### CORS
- تم تكوين CORS للسماح بالاتصال من localhost و Vercel domains

## اختبار الباك إند:
بعد النشر، يمكنك اختبار الباك إند من خلال:
- `https://your-project-name.vercel.app/` - الصفحة الرئيسية
- `https://your-project-name.vercel.app/api/test` - اختبار API
- `https://your-project-name.vercel.app/api/packages` - الباقات
- `https://your-project-name.vercel.app/api/washing-places` - محطات الغسيل

## تحديث رابط API في التطبيق:
بعد النشر، قم بتحديث `lib/core/config.dart` في التطبيق:
```dart
static const String apiBaseUrl = 'https://your-project-name.vercel.app/api';
``` 
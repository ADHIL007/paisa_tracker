<div align="center">
  
  <br><img width="80" height="80" alt="logo" src="https://github.com/user-attachments/assets/bc1a23f1-5b7f-459e-9747-897e1e807c55" />

  <b>Track every Rupee, Privately.</b>
</div>

<br>

**Paisa Tracker** is a privacy-first, minimalistic financial expense tracker designed for the modern Indian user. It operates **100% offline**, automatically parsing transaction SMS messages to categorize your spending without your data ever leaving your device.

---

## 🚀 Key Features

* **100% Offline Architecture:** No internet connection required. No external servers. Your financial data stays securely on your phone.
* **Automated SMS Parsing:** Intelligently scans transaction SMSs (OTP and spam filtered) to automatically log expenses.
* **Smart History Import:** On startup, easily import and categorize past transaction messages to get immediate financial insights.
* **Modern UI/UX:** A clean, "super-app" aesthetic inspired by modern fintech, featuring:
    * Flat, geometric design.
    * Clean typography.
    * Zero clutter.
* **Dual Theme Support:** Fully optimized **Dark Mode** and **Light Mode**.
* **Privacy Focused:** No data collection, no analytics tracking, no cloud sync.

## 📸 UI Concept 

<img width="1292" height="590" alt="dark_light1" src="https://github.com/user-attachments/assets/c9f739d0-5776-49fd-abc9-8c5c1a3ca1b7" />

<img width="1536" height="768" alt="ui2" src="https://github.com/user-attachments/assets/5437333d-f44c-4928-b370-4c27207420dd" />

## 🛠 Tech Stack

* **Framework:** [Flutter / React Native / Kotlin / Swift] *(Select your framework)*
* **Local Database:** [SQLite / Hive / Room / Realm]
* **State Management:** [Provider / Bloc / Redux / Riverpod]
* **Parsing Logic:** Custom RegEx for Indian Bank SMS formats

## 🔐 Privacy & Security

**Paisa Tracker is built on a "Zero-Knowledge" architecture.**

1.  **Local Processing:** All SMS parsing happens locally on the device's CPU.
2.  **No Network Calls:** The app does not request `INTERNET` permission (except for checking app updates if configured, otherwise purely offline).
3.  **Data Ownership:** Users can export their data to CSV/PDF locally. No cloud backups are performed unless initiated by the user to their own private storage.

## 📥 Installation

1.  **Clone the repo**
    ```sh
    git clone [https://github.com/yourusername/paisa-tracker.git](https://github.com/yourusername/paisa-tracker.git)
    ```

2.  **Install dependencies**
    ```sh
    flutter pub get
    ```

3.  **Run the app**
    ```sh
    flutter run
    ```

## 📱 Permissions

To function correctly, Paisa Tracker requires the following permissions:

* `READ_SMS`: To detect past financial transactions for the "History Import" feature.
* `RECEIVE_SMS`: To track expenses in real-time as they happen.

> **Note:** The app explicitly filters out and ignores OTPs, personal messages, and promotional spam.

## 🗺 Roadmap

- [ ] Core SMS Parsing Logic (HDFC, SBI, ICICI, UPI)
- [ ] Manual Transaction Entry
- [ ] Budget setting and alerts
- [ ] Visual charts (Pie/Bar graphs) for monthly analysis
- [ ] Export data to Excel/CSV

## 🤝 Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

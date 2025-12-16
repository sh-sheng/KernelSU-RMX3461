# KernelSU for Realme 9 5G Speed Edition (RMX3461)

Build KernelSU kernel cho Realme 9 5G Speed Edition sử dụng GitHub Actions.

## Device Info

| Property | Value |
|----------|-------|
| Device | Realme 9 5G Speed Edition |
| Model | RMX3461 |
| SoC | Snapdragon 778G (lahaina) |
| Kernel | 5.4.x |
| Android | 12 |

## Cách sử dụng

### Bước 1: Fork repository này

Click nút **Fork** ở góc phải trên.

### Bước 2: Chạy build

1. Vào tab **Actions**
2. Click **Build KernelSU for RMX3461**
3. Click **Run workflow**
4. Đợi build hoàn thành (~30-60 phút)

### Bước 3: Download

1. Khi build thành công, vào workflow run
2. Download artifact **KernelSU-RMX3461**
3. Extract file zip

### Bước 4: Flash

**Flash qua TWRP:**
```
1. Boot vào TWRP Recovery
2. Install → Select Storage
3. Chọn file KernelSU-RMX3461-xxxxx.zip
4. Swipe to Flash
5. Reboot
```

### Bước 5: Cài KernelSU Manager

Download từ: https://github.com/tiann/KernelSU/releases/tag/v0.9.5

## Lưu ý

- Sử dụng KernelSU v0.9.5 (phiên bản cuối hỗ trợ non-GKI)
- Backup boot.img gốc trước khi flash
- Bootloader phải đã unlock

## Credits

- [KernelSU](https://github.com/tiann/KernelSU)
- [Realme Kernel Source](https://github.com/realme-kernel-opensource)
- [AnyKernel3](https://github.com/osm0sis/AnyKernel3)

# Hướng dẫn Build KernelSU cho Realme 9 5G Speed Edition (RMX3461)

## Bước 1: Fork Repository KernelSU_Action

1. Đăng nhập GitHub tại: https://github.com
2. Truy cập: https://github.com/xiaoleGun/KernelSU_Action
3. Click nút **Fork** (góc phải trên)
4. Đặt tên repo: `KernelSU_RMX3461` (hoặc tên tùy ý)
5. Click **Create fork**

## Bước 2: Upload file config.env

1. Trong repo vừa fork, mở file `config.env`
2. Click biểu tượng **Edit** (hình bút chì)
3. **Xóa toàn bộ nội dung cũ**
4. Copy nội dung từ file `config.env` trong thư mục này
5. Dán vào editor
6. Scroll xuống, nhập commit message: "Update config for RMX3461"
7. Click **Commit changes**

## Bước 3: Chạy Build Workflow

1. Vào tab **Actions** trong repo của bạn
2. Nếu thấy thông báo "Workflows aren't being run...", click **I understand my workflows, go ahead and enable them**
3. Click **Build Kernel** ở sidebar trái
4. Click dropdown **Run workflow** (góc phải)
5. Chọn branch: `main`
6. Click nút **Run workflow** màu xanh

## Bước 4: Theo dõi Build Process

- Build thường mất **30-60 phút**
- Bạn có thể click vào workflow run để xem logs
- Nếu thấy **lỗi đỏ**, kiểm tra logs để debug

### Các lỗi thường gặp và cách sửa:

| Lỗi | Giải pháp |
|-----|-----------|
| `defconfig not found` | Thử thay `KERNEL_CONFIG` bằng các option khác trong comment |
| `error: unknown option` | Thử set `DISABLE_CC_WERROR=true` |
| `out of memory` | Set `DISABLE_LTO=true` |
| `kprobe not working` | Giữ `APPLY_KERNELSU_PATCH=true` |

## Bước 5: Download Artifacts

Khi build thành công (tick xanh ✅):

1. Click vào workflow run đã hoàn thành
2. Scroll xuống phần **Artifacts**
3. Download file:
   - `AnyKernel3-xxx.zip` - File flash kernel
   - `dtbo.img` (nếu có) - DTBO image

## Bước 6: Flash Kernel

### Option A: Flash qua TWRP Recovery

```
1. Copy file AnyKernel3-xxx.zip vào điện thoại
2. Boot vào TWRP: Power + Volume Down
3. Chọn Install
4. Navigate đến file zip
5. Swipe to Flash
6. Reboot System
```

### Option B: Flash qua Fastboot

Nếu bạn có file `boot.img`:
```bash
# Kết nối điện thoại với PC
adb reboot bootloader

# Flash kernel
fastboot flash boot boot-kernelsu.img

# Reboot
fastboot reboot
```

## Bước 7: Cài đặt KernelSU Manager

1. Download KernelSU Manager v0.9.5:
   https://github.com/tiann/KernelSU/releases/tag/v0.9.5
   
2. Cài đặt file `KernelSU_v0.9.5_xxx-release.apk`

3. Mở app, kiểm tra:
   - Status: **Working** ✅
   - Kernel version hiển thị đúng

## Xác nhận thành công

- [ ] Điện thoại boot bình thường
- [ ] KernelSU Manager hiển thị "Working"
- [ ] Có thể grant su permission cho apps
- [ ] Các modules hoạt động (nếu cài)

## Liên kết hữu ích

- [KernelSU Documentation](https://kernelsu.org/)
- [KernelSU Releases](https://github.com/tiann/KernelSU/releases)
- [XDA - Realme 9 5G SE](https://xdaforums.com/f/realme-9-5g-speed-edition-rmx3461.12637/)
- [Realme Bootloader Unlock](https://www.realme.com/in/support/kw/doc/2073678)

## Troubleshooting

### Bootloop sau khi flash

1. Boot vào Recovery (Power + Vol Up)
2. Chọn **Wipe** > **Advanced Wipe** > **Dalvik/Cache**
3. Reboot

Nếu vẫn bootloop:
1. Boot vào Fastboot (Power + Vol Down)
2. Flash lại boot gốc:
   ```bash
   fastboot flash boot boot_original.img
   ```

### KernelSU không nhận diện

1. Kiểm tra lại version Manager (phải dùng v0.9.5)
2. Thử reboot điện thoại
3. Kiểm tra trong Settings > About phone > Kernel version

setenv kernel_filename "zImage"
setenv fdtfile "bcm2708-rpi-b.dtb"
setenv bootargs "root=/dev/mmcblk0p2 rootwait console=tty1 console=ttyAMA0,115200"

echo > Loading Kernel...
ext4load mmc 0:2 ${kernel_addr_r} "boot/${kernel_filename}"
echo > Loading FDT...
ext4load mmc 0:2 ${fdt_addr_r} "boot/${fdtfile}"

echo > Booting System...
bootz ${kernel_addr_r} - ${fdt_addr_r}

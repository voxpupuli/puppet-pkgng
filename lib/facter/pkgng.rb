
Facter.add("pkgng_supported") do
  confine :kernel => "FreeBSD"

  setcode do
    kernel = Facter.value('kernelrelease')
    if kernel.grep(/^9|^10/)
      "true"
    end
  end

end

Facter.add("pkgng_enabled") do
  confine :kernel => "FreeBSD"

  setcode do
    if %x{/usr/bin/make -f /etc/make.conf -VWITH_PKGNG} =~ /(yes|true)/
      "true"
    end
  end

end

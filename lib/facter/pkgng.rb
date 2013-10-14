
Facter.add("pkgng_supported") do
  confine :kernel => "FreeBSD"

  setcode do
    kernel = Facter.value('kernelversion')
    if kernel =~ /^(9|10)(\.[0-9])?/
      "true"
    end
  end

end

Facter.add("pkgng_enabled") do
  confine :kernel => "FreeBSD"

  setcode do
    if %x{/usr/bin/make -f /etc/make.conf -VWITH_PKGNG} =~ /(yes|true)/i
      "true"
    end if File.exist?('/etc/make.conf')
  end

end

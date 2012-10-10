
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
    if File.readlines('/etc/make.conf') =~ /WITH_PKGNG=(yes|true)/
      "true"
    end if File.exist?('/etc/make.conf')
  end

end

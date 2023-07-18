# The protocol for a pkg mirror
type Pkgng::Protocol = Enum[
  'file',
  'ftp',
  'http',
  'https',
  'ssh',
]

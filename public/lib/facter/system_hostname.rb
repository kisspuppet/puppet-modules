#------------define fact --------------------
Facter.add(:system_hostname) do
  setcode do
    %x{/bin/hostname}.chomp
  end
end
Facter.add(:system_hostname_az) do
  setcode do
    %x{/bin/hostname |/usr/bin/tr '[A-Z]' '[a-z]'}.chomp
  end
end

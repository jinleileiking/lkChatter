a = [1,2,3]

a = a << 3

a = a.uniq

p a


a = a << 3 unless a.include?(3)

p a


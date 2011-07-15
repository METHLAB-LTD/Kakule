#copy and paste this script into console.
#EOF Error means it finished running.

# f=File.open("db/timeZones.txt", "r")
# 
# 
# while(true)
#   line = f.readline()
#   arr = line.strip.split("\t")
#   Timezone.create({
#     :name => arr[0],
#     :gmt_offset => arr[1].to_f,
#     :dst_offset => arr[2].to_f
#   })
# end
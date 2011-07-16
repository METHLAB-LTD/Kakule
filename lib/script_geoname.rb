#copy and paste this script into console.
#NOTE: Run this after Timezone Script is complete.
#EOF Error means it finished running.

def find_country(code)
  hash = {"VA"=>"Vatican City State", "CC"=>"Cocos Slands", "GT"=>"Guatemala", "JP"=>"Japan", "SE"=>"Sweden", "TZ"=>"Tanzania", "CD"=>"The Democratic Republic Of The Congo", "GU"=>"Guam", "MM"=>"Myanmar", "DZ"=>"Algeria", "MN"=>"Mongolia", "PK"=>"Pakistan", "SG"=>"Singapore", "VC"=>"Saint Vincent And The Grenadines", "CF"=>"Central African Republic", "GW"=>"Guinea-bissau", "MO"=>"Macao", "PL"=>"Poland", "SH"=>"Saint Helena, Ascension And Tristan Da Cunha", "CG"=>"Congo", "MP"=>"Northern Mariana Islands", "PM"=>"Saint Pierre And Miquelon", "SI"=>"Slovenia", "VE"=>"Venezuela", "ZW"=>"Zimbabwe", "CH"=>"Switzerland", "GY"=>"Guyana", "MQ"=>"Martinique", "PN"=>"Pitcairn", "SJ"=>"Svalbard And Jan Mayen", "CI"=>"Cote D'ivoire", "MR"=>"Mauritania", "SK"=>"Slovakia", "VG"=>"British Virgin Islands", "MS"=>"Montserrat", "SL"=>"Sierra Leone", "CK"=>"Cook Islands", "ID"=>"Indonesia", "MT"=>"Malta", "SM"=>"San Marino", "VI"=>"U.s. Virgin Islands", "YE"=>"Yemen", "CL"=>"Chile", "IE"=>"Ireland", "LA"=>"Lao People's Democratic Republic", "MU"=>"Mauritius", "SN"=>"Senegal", "CM"=>"Cameroon", "FI"=>"Finland", "LB"=>"Lebanon", "MV"=>"Maldives", "PR"=>"Puerto Rico", "SO"=>"Somalia", "CN"=>"China", "FJ"=>"Fiji", "LC"=>"Saint Lucia", "MW"=>"Malawi", "PS"=>"Palestine", "CO"=>"Colombia", "FK"=>"Falkland Islands", "MX"=>"Mexico", "PT"=>"Portugal", "MY"=>"Malaysia", "SR"=>"Suriname", "VN"=>"Vietnam", "FM"=>"Federated States Of Micronesia", "MZ"=>"Mozambique", "CR"=>"Costa Rica", "PW"=>"Palau", "FO"=>"Faroe Islands", "ST"=>"Sao Tome And Principe", "IL"=>"Israel", "LI"=>"Liechtenstein", "PY"=>"Paraguay", "BA"=>"Bosnia And Herzegovina", "CU"=>"Cuba", "IM"=>"Isle Of Man", "SV"=>"El Salvador", "CV"=>"Cape Verde", "FR"=>"France", "IN"=>"India", "LK"=>"Sri Lanka", "BB"=>"Barbados", "CW"=>"Curacao", "IO"=>"British Indian Ocean Territory", "SX"=>"Dutch Sint Maarten", "VU"=>"Vanuatu", "CX"=>"Christmas Island", "RE"=>"Reunion", "UA"=>"Ukraine", "SY"=>"Syrian Arab Republic", "CY"=>"Cyprus", "IQ"=>"Iraq", "SZ"=>"Swaziland", "BD"=>"Bangladesh", "CZ"=>"Czech Republic", "IR"=>"Islamic Republic Of Iran", "YT"=>"Mayotte", "BE"=>"Belgium", "IS"=>"Iceland", "BF"=>"Burkina Faso", "EC"=>"Ecuador", "IT"=>"Italy", "OM"=>"Oman", "BG"=>"Bulgaria", "BH"=>"Bahrain", "LR"=>"Liberia", "UG"=>"Uganda", "BI"=>"Burundi", "EE"=>"Estonia", "LS"=>"Lesotho", "BJ"=>"Benin", "LT"=>"Lithuania", "EG"=>"Egypt", "BL"=>"Saint Barthelemy", "EH"=>"Western Sahara", "LU"=>"Luxembourg", "RO"=>"Romania", "BM"=>"Bermuda", "LV"=>"Latvia", "BN"=>"Brunei Darussalam", "UM"=>"United States Minor Outlying Islands", "BO"=>"Bolivia", "KE"=>"Kenya", "NA"=>"Namibia", "LY"=>"Libyan Arab Jamahiriya", "XK"=>"Kosovo", "BQ"=>"Bonaire", "HOLY SEE"=>"Vatican City State", "BR"=>"Brazil", "KG"=>"Kyrgyzstan", "NC"=>"New Caledonia", "RS"=>"Serbia", "BS"=>"Bahamas", "HK"=>"Hong Kong", "KH"=>"Cambodia", "BT"=>"Bhutan", "KI"=>"Kiribati", "NE"=>"Niger", "QA"=>"Qatar", "RU"=>"Russian Federation", "HM"=>"Heard Island And Mcdonald Islands", "NF"=>"Norfolk Island", "US"=>"United States", "BV"=>"Bouvet Island", "ER"=>"Eritrea", "HN"=>"Honduras", "NG"=>"Nigeria", "RW"=>"Rwanda", "BW"=>"Botswana", "ES"=>"Spain", "ET"=>"Ethiopia", "NI"=>"Nicaragua", "AD"=>"Andorra", "BY"=>"Belarus", "KM"=>"Comoros", "AE"=>"United Arab Emirates", "BZ"=>"Belize", "HR"=>"Croatia", "KN"=>"Saint Kitts And Nevis", "TC"=>"Turks And Caicos Islands", "AF"=>"Afghanistan", "NL"=>"Netherlands", "TD"=>"Chad", "AG"=>"Antigua And Barbuda", "HT"=>"Haiti", "KP"=>"North Korea", "UY"=>"Uruguay", "GA"=>"Gabon", "HU"=>"Hungary", "TF"=>"French Southern Territories", "UZ"=>"Uzbekistan", "AI"=>"Anguilla", "DE"=>"Germany", "GB"=>"United Kingdom", "KR"=>"South Korea", "TG"=>"Togo", "NO"=>"Norway", "TH"=>"Thailand", "GD"=>"Grenada", "NP"=>"Nepal", "ZA"=>"South Africa", "AL"=>"Albania", "GE"=>"Georgia", "TJ"=>"Tajikistan", "WF"=>"Wallis And Futuna", "AM"=>"Armenia", "GF"=>"French Guiana", "NR"=>"Nauru", "TK"=>"Tokelau", "DJ"=>"Djibouti", "KW"=>"Kuwait", "TL"=>"Timor-leste", "AO"=>"Angola", "DK"=>"Denmark", "GG"=>"Guernsey", "TM"=>"Turkmenistan", "GH"=>"Ghana", "JE"=>"Jersey", "MA"=>"Morocco", "KY"=>"Cayman Islands", "NU"=>"Niue", "TN"=>"Tunisia", "DM"=>"Dominica", "GI"=>"Gibraltar", "KZ"=>"Kazakhstan", "TO"=>"Tonga", "AQ"=>"Antarctica", "MC"=>"Monaco", "AR"=>"Argentina", "MD"=>"Republic Of Moldova", "AS"=>"American Samoa", "DO"=>"Dominican Republic", "ME"=>"Montenegro", "PA"=>"Panama", "TR"=>"Turkey", "AT"=>"Austria", "GL"=>"Greenland", "MF"=>"Saint Martin (french Part)", "NZ"=>"New Zealand", "AU"=>"Australia", "GM"=>"Gambia", "GN"=>"Guinea", "MG"=>"Madagascar", "AW"=>"Aruba", "MH"=>"Marshall Islands", "TT"=>"Trinidad And Tobago", "ZM"=>"Zambia", "GP"=>"Guadeloupe", "AX"=>"Aland Islands", "SA"=>"Saudi Arabia", "PE"=>"Peru", "JM"=>"Jamaica", "GQ"=>"Equatorial Guinea", "CA"=>"Canada", "WS"=>"Samoa", "SB"=>"Solomon Islands", "PF"=>"French Polynesia", "TV"=>"Tuvalu", "PG"=>"Papua New Guinea", "MK"=>"Macedonia", "GR"=>"Greece", "AZ"=>"Azerbaijan", "TW"=>"Taiwan, Province Of China", "SC"=>"Seychelles", "PH"=>"Philippines", "ML"=>"Mali", "JO"=>"Jordan", "GS"=>"South Georgia And The South Sandwich Islands", "SD"=>"Sudan"}
  return hash[code.upcase]
end

def find_state(code)
  hash = {"VA"=>"Virginia", "ND"=>"North Dakota", "NY"=>"New York", "AL"=>"Alabama", "RI"=>"Rhode Island", "NE"=>"Nebraska", "MN"=>"Minnesota", "MD"=>"Maryland", "HI"=>"Hawaii", "DE"=>"Delaware", "CO"=>"Colorado", "WY"=>"Wyoming", "PR"=>"Puerto Rico", "MO"=>"Missouri", "ME"=>"Maine", "IA"=>"Iowa", "OR"=>"Oregon", "OH"=>"Ohio", "MP"=>"Northern Mariana Islands", "KY"=>"Kentucky", "IL"=>"Illinois", "GU"=>"Guam", "AZ"=>"Arizona", "TX"=>"Texas", "TN"=>"Tennessee", "NH"=>"New Hampshire", "GA"=>"Georgia", "SC"=>"South Carolina", "MH"=>"Marshall Islands", "IN"=>"Indiana", "ID"=>"Idaho", "SD"=>"South Dakota", "PA"=>"Pennsylvania", "OK"=>"Oklahoma", "NJ"=>"New Jersey", "MS"=>"Mississippi", "MI"=>"Michigan", "FL"=>"Florida", "CT"=>"Connecticut", "AR"=>"Arkansas", "WI"=>"Wisconsin", "PW"=>"Palau", "MT"=>"Montana", "FM"=>"Federated States Of Micronesia", "AS"=>"American Samoa", "VI"=>"Virgin Islands", "VT"=>"Vermont", "NV"=>"Nevada", "KS"=>"Kansas", "CA"=>"California", "WV"=>"West Virginia", "UT"=>"Utah", "NM"=>"New Mexico", "MA"=>"Massachusetts", "DC"=>"DC", "WA"=>"Washington", "NC"=>"North Carolina", "LA"=>"Louisiana", "AK"=>"Alaska"}
  return hash[code.upcase] 
end

def find_timezone(code)
  Timezone.find_by_name(code)
end

# point this file to the .txt that location data is in
f=File.open("db/cities15000.txt", "r")


while(true)
  line = f.readline()
  arr = line.split("\t")
  
  name = arr[2].split(" ").map{|x| x.capitalize}.join(" ")
  lat = arr[4]
  lng = arr[5]
  country = find_country(arr[8])
  state = (arr[8] == "US" ? find_state(arr[10]) : "")
  population = arr[14]
  gtopo30 = arr[16]
  timezone = find_timezone(arr[17])
  
  Geocode.create({
    :name => name,
    :latitude => lat,
    :longitude => lng,
    :state => state,
    :country => country,
    :population => population,
    :gtopo30 => gtopo30,
    :timezone => timezone
  })
end



  

class CraigslistSource

    attr_accessor :subdomain
    attr_accessor :max_rent

    def subdomain=(subdomain)
        if !(KNOWN_CRAIGSLIST_SUBDOMAINS.include? subdomain)
            raise 'Not a known Craigslist region'
        else
            @subdomain = subdomain
        end
    end

    def make_request
        begin
        xml_string = RestClient.get(rss_template_apa)
        rescue RestClient::ResourceNotFound => error
            # Try specific "all apartments" (newyork)
            xml_string = RestClient.get(rss_template_aap)
        end
        xml_doc = Nokogiri::XML(xml_string)

        formatted_result = "#{xml_doc.css('title').first.text}\n\n"

        xml_doc.css("item").each do |item|
            title = item.css("title").first.text[0..30]
            link = item.css("link").first.text
            formatted_result += "* #{title} - #{link}\n"
        end

        formatted_result
    end

    private

    KNOWN_CRAIGSLIST_SUBDOMAINS = ["auburn","bham","dothan","shoals","gadsden","huntsville","mobile","montgomery","tuscaloosa","anchorage","fairbanks","kenai","juneau","flagstaff","mohave","phoenix","prescott","showlow","sierravista","tucson","yuma","fayar","fortsmith","jonesboro","littlerock","texarkana","bakersfield","chico","fresno","goldcountry","hanford","humboldt","imperial","inlandempire","losangeles","mendocino","merced","modesto","monterey","orangecounty","palmsprings","redding","sacramento","sandiego","sfbay","slo","santabarbara","santamaria","siskiyou","stockton","susanville","ventura","visalia","yubasutter","boulder","cosprings","denver","eastco","fortcollins","rockies","pueblo","westslope","newlondon","hartford","newhaven","nwct","delaware","washingtondc","daytona","keys","fortlauderdale","fortmyers","gainesville","cfl","jacksonville","lakeland","lakecity","ocala","okaloosa","orlando","panamacity","pensacola","sarasota","miami","spacecoast","staugustine","tallahassee","tampa","treasure","westpalmbeach","albanyga","athensga","atlanta","augusta","brunswick","columbusga","macon","nwga","savannah","statesboro","valdosta","honolulu","boise","eastidaho","lewiston","twinfalls","bn","chambana","chicago","decatur","lasalle","mattoon","peoria","rockford","carbondale","springfieldil","quincy","bloomington","evansville","fortwayne","indianapolis","kokomo","tippecanoe","muncie","richmondin","southbend","terrehaute","ames","cedarrapids","desmoines","dubuque","fortdodge","iowacity","masoncity","quadcities","siouxcity","ottumwa","waterloo","lawrence","ksu","nwks","salina","seks","swks","topeka","wichita","bgky","eastky","lexington","louisville","owensboro","westky","batonrouge","cenla","houma","lafayette","lakecharles","monroe","neworleans","shreveport","maine","annapolis","baltimore","easternshore","frederick","smd","westmd","boston","capecod","southcoast","westernmass","worcester","annarbor","battlecreek","centralmich","detroit","flint","grandrapids","holland","jxn","kalamazoo","lansing","monroemi","muskegon","nmi","porthuron","saginaw","swmi","thumb","up","bemidji","brainerd","duluth","mankato","minneapolis","rmn","marshall","stcloud","gulfport","hattiesburg","jackson","meridian","northmiss","natchez","columbiamo","joplin","kansascity","kirksville","loz","semo","springfield","stjoseph","stlouis","billings","bozeman","butte","greatfalls","helena","kalispell","missoula","montana","grandisland","lincoln","northplatte","omaha","scottsbluff","elko","lasvegas","reno","nh","cnj","jerseyshore","newjersey","southjersey","albuquerque","clovis","farmington","lascruces","roswell","santafe","albany","binghamton","buffalo","catskills","chautauqua","elmira","fingerlakes","glensfalls","hudsonvalley","ithaca","longisland","newyork","oneonta","plattsburgh","potsdam","rochester","syracuse","twintiers","utica","watertown","asheville","boone","charlotte","eastnc","fayetteville","greensboro","hickory","onslow","outerbanks","raleigh","wilmington","winstonsalem","bismarck","fargo","grandforks","nd","akroncanton","ashtabula","athensohio","chillicothe","cincinnati","cleveland","columbus","dayton","limaohio","mansfield","sandusky","toledo","tuscarawas","youngstown","zanesville","lawton","enid","oklahomacity","stillwater","tulsa","bend","corvallis","eastoregon","eugene","klamath","medford","oregoncoast","portland","roseburg","salem","altoona","chambersburg","erie","harrisburg","lancaster","allentown","meadville","philadelphia","pittsburgh","poconos","reading","scranton","pennstate","williamsport","york","providence","charleston","columbia","florencesc","greenville","hiltonhead","myrtlebeach","nesd","csd","rapidcity","siouxfalls","sd","chattanooga","clarksville","cookeville","jacksontn","knoxville","memphis","nashville","tricities","abilene","amarillo","austin","beaumont","brownsville","collegestation","corpuschristi","dallas","nacogdoches","delrio","elpaso","galveston","houston","killeen","laredo","lubbock","mcallen","odessa","sanangelo","sanantonio","sanmarcos","bigbend","texoma","easttexas","victoriatx","waco","wichitafalls","logan","ogden","provo","saltlakecity","stgeorge","burlington","charlottesville","danville","fredericksburg","norfolk","harrisonburg","lynchburg","blacksburg","richmond","roanoke","swva","winchester","bellingham","kpr","moseslake","olympic","pullman","seattle","skagit","spokane","wenatchee","yakima","charlestonwv","martinsburg","huntington","morgantown","wheeling","parkersburg","swv","wv","appleton","eauclaire","greenbay","janesville","racine","lacrosse","madison","milwaukee","northernwi","sheboygan","wausau","wyoming","micronesia","puertorico","virgin","brussels","bulgaria","zagreb","copenhagen","bordeaux","rennes","grenoble","lille","loire","lyon","marseilles","montpellier","cotedazur","rouen","paris","strasbourg","toulouse","budapest","reykjavik","dublin","luxembourg","amsterdam","oslo","bucharest","moscow","stpetersburg","ukraine","bangladesh","micronesia","jakarta","tehran","baghdad","haifa","jerusalem","telaviv","ramallah","kuwait","beirut","malaysia","pakistan","dubai","vietnam","auckland","christchurch","wellington","buenosaires","lapaz","belohorizonte","brasilia","curitiba","fortaleza","portoalegre","recife","rio","salvador","saopaulo","caribbean","santiago","colombia","costarica","santodomingo","quito","elsalvador","guatemala","managua","panama","lima","puertorico","montevideo","caracas","virgin","cairo","addisababa","accra","kenya","casablanca","tunis"]


    def rss_template_apa
        "http://#{@subdomain}.craigslist.org/search/apa?maxAsk=#{@max_rent}&format=rss"
    end

    def rss_template_aap
        "http://#{@subdomain}.craigslist.org/search/aap?maxAsk=#{@max_rent}&format=rss"
    end
end

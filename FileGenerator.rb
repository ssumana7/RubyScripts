$replaceStr_img = ""
$replaceStr_hp = ""
$isExists = false
def getStr(fname, name, url)
	tcfile = File.open(fname,'r+')
	str = tcfile.read()
	str = str.gsub("__NAME__", name)
	str = str.gsub("__URL__", url)
	return str
end

def generate_testcase(template_fname, fname, name, jsonId, url)
	if File.exist?(fname)
        puts "File name #{fname} already exists"
        isExists = true
	else
		if fname.include? "installation"
			$replaceStr_hp.concat("<rpTestCaseRef name=\"Widget_installation_#{name}\" />\n");
		else
			url = jsonId
			$replaceStr_img.concat("<rpTestCaseRef name=\"Widget_JSON_#{name}_#{jsonId}\"/>\n");
		end
		puts "File Created - #{fname} "
		replaceStr = getStr(template_fname, name, url);
		tcfile = File.open(fname, 'w+')
		tcfile.write(replaceStr)
		tcfile.close()
	end	
end

def updateXMLSuite(token, str)
	puts "Test - #{str}"
	suite_template = File.open("template_testsuites.xml", 'r')
	replaceStr = suite_template.read()
	replaceStr = replaceStr.gsub(token, str)
	suite_template.close()
	suite = File.open("testsuites.xml", 'w')
	
	suite.write(replaceStr)
	suite_template = File.open("template_testsuites.xml", 'w')
	suite_template.write(replaceStr)
	suite.close()
	suite_template.close()
end



ishpExists = false
File.open("widgets1.csv", 'r').each_line do |line|
		widgets = line.split(',')
		url = widgets[2].delete("\n")

		fname_img = "/Users/SumanaKalyan/src/RubyScripts/testcases1/Widget_JSON_#{widgets[0]}_#{widgets[1]}.xml"
		fname_hp = "/Users/SumanaKalyan/src/RubyScripts/testcases1/Widget_installation_#{widgets[0]}.xml"
		
		generate_testcase("template_testcase.xml", fname_img, widgets[0], widgets[1],url)
		generate_testcase("template_testcase_homepage.xml", fname_hp, widgets[0],widgets[1],url)      
        
end

if !($isExists)
	puts "hello"
	updateXMLSuite("__widgets_testcases_homepage__",$replaceStr_hp)
	updateXMLSuite("__widgets_testcases_json__",$replaceStr_img)
end
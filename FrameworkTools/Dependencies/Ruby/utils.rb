require 'xcodeproj'

puts("we did it!")

def project_from_name(name)
	project = Xcodeproj::Project.new("#{name}.xcodeproj")
	project.initialize_from_file
	return project
end

# Groups

# Returns frameworks PBXGroup. Creates one if it has to
def frameworks_group(project)
	if project.main_group['Frameworks'] == nil then
		return project.main_group.new_group('Frameworks')
	end
	return project.main_group['Frameworks']
end

def ios_frameworks_group(project)
	if frameworks_group(project)['iOS'] == nil then
		return frameworks_group(project).new_group('iOS')
	end
	return project.main_group['Frameworks']['iOS']
end

def osx_frameworks_group(project)
	if frameworks_group(project)['OS X'] == nil then
		return frameworks_group(project).new_group('OS X')
	end
	return project.main_group['Frameworks']['OS X']
end

# Schemes

def ios_scheme(name)
	path = "#{Dir.pwd}/#{name}.xcodeproj/xcshareddata/xcschemes/#{name}.xcscheme"
	Xcodeproj::XCScheme.new(path)
end

def osx_scheme(name)
	path = "#{Dir.pwd}/#{name}.xcodeproj/xcshareddata/xcschemes/#{name}Mac.xcscheme"
	return Xcodeproj::XCScheme.new(path)
end

# Targets

def ios_target(project)
	for target in project.targets do
		if is_framework(target) && is_iOS(target) then return target end
	end
	return nil
end

def ios_tests_target(project)
	for target in project.targets do
		if is_test_bundle(target) && is_iOS(target) then return target end
	end
	return nil
end

def osx_target(project)
	for target in project.targets do
		if is_framework(target) && is_OSX(target) then return target end
	end
	return nil
end

def osx_tests_target(project)
	for target in project.targets do
		if is_test_bundle(target) && is_OSX(target) then return target end
	end
	return nil
end

def target_from_name(name, project) 
	case name
	when "ios"
		return ios_target(project)
	when "ios_tests"
		return ios_tests_target(project)
	when "osx"
		return osx_target(project)
	when "osx_tests"
		return osx_tests_target(project)
	else 
		return nil
	end
end

def is_framework(target)
	return target.product_type == 'com.apple.product-type.framework'
end

def is_test_bundle(target)
	return target.product_type == 'com.apple.product-type.bundle.unit-test'
end

def is_iOS(target)
	return target.platform_name == :ios
end

def is_OSX(target)
	return target.platform_name == :osx
end


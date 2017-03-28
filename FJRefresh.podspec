Pod::Spec.new do |s|
    s.name         = 'FJRefresh'
    s.version      = '0.0.1'
    s.summary      = 'An extend pull-to-refresh component based on MJRefresh'
    s.homepage     = 'https://github.com/jeffnjut/FJRefresh'
    s.license      = 'MIT'
    s.authors      = {'jeff_njut' => 'jeff_njut@163.com'}
    s.platform     = :ios, '8.0'
    s.source       = {:git => 'https://github.com/jeffnjut/FJRefresh.git', :tag => s.version}
    s.source_files = 'FJRefresh/**/*.{h,m}'
    s.resources    = "FJRefresh/**/*.{xib,png}"
    s.requires_arc = true
    s.dependency   'MJRefresh'
end

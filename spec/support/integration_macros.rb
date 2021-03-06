require 'factories'
module IntegrationMacros
	def should_have_translations( html )
		tl_miss = /<span class="translation_missing" \w+=".+">.+<\/span>/
		specific = /en\.[\.\w\d\-_]+/
		missing = [];
		html.gsub( tl_miss ) do |span|
			span.gsub(specific) do |spec|
				missing << spec
			end # each spec
		end # each span
		missing << html.match(/<title>.+<\/title>/)[0] unless missing.empty? || html.match(/<title>.+<\/title>/).nil?
		missing.should eq []
	end # should_have translations
end # IntegrationMacros


class SignetifyGenerator < Rails::Generators::NamedBase
  source_root(File.expand_path("../templates", __FILE__))

  def install
    copy_file 'signetify.yml', 'config/signetify.yml'
  end
end

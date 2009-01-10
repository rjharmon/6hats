namespace :doc do
  namespace :diagram do
    desc "Generate model diagrams in doc/models.{svg,dot}"
    task :models do
      sh "railroad -i -l -a -m -M | tee doc/models.dot | cat doc/models.dot | dot -Tsvg | sed 's/font-size:14.00/font-size:11.00/g' > doc/models.svg"
    end

    desc "Generate model diagrams in doc/controllers.{svg,dot}"
    task :controllers do
      sh "railroad -i -l -C | neato | tee doc/controllers.dot | dot -Tsvg | sed 's/font-size:14.00/font-size:11.00/g' > doc/controllers.svg"
    end
  end

  desc "Generate model and controller diagrams, both"
  task :diagrams => %w(diagram:models diagram:controllers)
end

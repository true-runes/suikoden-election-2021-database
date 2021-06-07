class CreateAnalyzeSyntaxes < ActiveRecord::Migration[6.1]
  def change
    create_table :analyze_syntaxes do |t|
      t.string :language

      # https://googleapis.dev/ruby/google-cloud-language-v1/latest/Google/Cloud/Language/V1/AnalyzeSyntaxResponse.html
      t.text :sentences, array: true # レスポンスの生ログを保存する目的
      t.text :tokens, array: true # レスポンスの生ログを保存する目的

      t.references :tweet

      t.timestamps
    end
  end
end

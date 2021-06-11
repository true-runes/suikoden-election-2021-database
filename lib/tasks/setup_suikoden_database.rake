require 'csv'

# rubocop:disable Layout/IndentationConsistency
namespace :setup_suikoden_database do
  desc 'Setup "Suikoden Database (beta)" tables data'
  task create: :environment do
    product_rows = CSV.read(Rails.root.join('db/seed_csvs/products.csv'), headers: true)
    character_name_rows = CSV.read(Rails.root.join('db/seed_csvs/characters.csv'), headers: true)
    nickname_rows = CSV.read(Rails.root.join('db/seed_csvs/nicknames.csv'), headers: true)

    puts "=== Suikoden Database Creation: START ==="
    ActiveRecord::Base.transaction do
      product_rows.each do |product_row|
        product = Product.new(
          name: product_row['name'],
          name_en: product_row['name_en']
        )

        product.save! if Product.find_by(name: product_row['name']).blank?
      end

      s1 = Product.find_by(name: '幻想水滸伝')
      s2 = Product.find_by(name: '幻想水滸伝II')
      s3 = Product.find_by(name: '幻想水滸伝III')
      s4 = Product.find_by(name: '幻想水滸伝IV')
      s5 = Product.find_by(name: '幻想水滸伝V')
      gaiden_1 = Product.find_by(name: '幻想水滸外伝Vol.1')
      gaiden_2 = Product.find_by(name: '幻想水滸外伝Vol.2')
      rhapsodia = Product.find_by(name: 'Rhapsodia')
      tierkreis = Product.find_by(name: '幻想水滸伝ティアクライス')
      tsumutoki = Product.find_by(name: '幻想水滸伝 紡がれし百年の時')
      _cadsto = Product.find_by(name: '幻想水滸伝 カードストーリーズ')

      character_name_rows.each do |cn_row|
        next if cn_row['総選挙でのキャラ名（フルネーム）'].blank?

        products_starring_character = [
          cn_row['幻水1'] == 'TRUE' ? s1 : nil,
          cn_row['幻水2'] == 'TRUE' ? s2 : nil,
          cn_row['幻水3'] == 'TRUE' ? s3 : nil,
          cn_row['幻水4'] == 'TRUE' ? s4 : nil,
          cn_row['幻水5'] == 'TRUE' ? s5 : nil,
          cn_row['外1'] == 'TRUE' ? gaiden_1 : nil,
          cn_row['外2'] == 'TRUE' ? gaiden_2 : nil,
          cn_row['R'] == 'TRUE' ? rhapsodia : nil,
          cn_row['TK'] == 'TRUE' ? tierkreis : nil,
          cn_row['紡時'] == 'TRUE' ? tsumutoki : nil,
        ].compact

        character_attrs = {
          name: cn_row['総選挙でのキャラ名（フルネーム）'],
          name_en: 'PENDING',
          products: products_starring_character
        }
        character = Character.new(character_attrs)

        # TODO: 'キャラ名' は UNIQUE にすべき
        # FIXED: ゴードンは複数いるので例外的に追加書き込みを許す（ただし、冪等ではなくなる）
        character.save! # FIXED: if Character.find_by(name: cn_row['総選挙でのキャラ名（フルネーム）']).blank? || cn_row['総選挙でのキャラ名（フルネーム）'] == 'ゴードン'
      end

      # キャラ名,別名1,別名2,別名3,別名4,別名5,別名6,別名7,別名8,別名9,別名10...
      # nn_row.class #=> CSV::Row
      nickname_rows.each do |nn_row|
        # 重複セルや空白セルがあった場合にそれ吸収して fix する
        fixed_nn_row = nn_row.values_at.compact.uniq #=> Array
        number_of_loop = fixed_nn_row.size
        gensosenkyo_character_name = nn_row.values_at[0]

        number_of_loop.times do |i|
          nickname_attrs = {
            name: fixed_nn_row[i]
          }
          # FIXED: 同名キャラがいる場合は動作がおかしくなる可能性がある (find_by でなく where を使うべき) -> 同名キャラを入れないようにした（DBレベルの制約やバリデーションはまだ）
          # characters テーブルと nicknames テーブルは、character_name で紐付けをする
          target_character = Character.find_by(name: gensosenkyo_character_name)
          nickname_attrs.merge!(characters: [target_character]) if target_character.present?

          nickname = Nickname.new(nickname_attrs)
          nickname.save!
        end
      end

    puts "=== Suikoden Database Creation: END ==="
    end
  end

  desc 'Drop "Suikoden Database (beta)" tables data'
  task destroy: :environment do
    product_rows = CSV.read(Rails.root.join('db/seed_csvs/products.csv'), headers: true)
    character_name_rows = CSV.read(Rails.root.join('db/seed_csvs/characters.csv'), headers: true)
    nickname_rows = CSV.read(Rails.root.join('db/seed_csvs/nicknames.csv'), headers: true)

    puts "=== Suikoden Database Destrunction: START ==="
    ActiveRecord::Base.transaction do
      product_rows.each do |product_row|
        product = Product.find_by(
          name: product_row['name'],
          name_en: product_row['name_en']
        )

        product.destroy! if product.present?
      end

      character_name_rows.each do |cn_row|
        character = Character.where(name: cn_row['総選挙でのキャラ名（フルネーム）'])

        character.destroy_all if character.present?
      end

      nickname_rows.each do |nn_row|
        number_of_loop = nn_row.values_at.compact.size

        number_of_loop.times do |i|
          next if i == 0

          nickname = Nickname.where(name: nn_row.values_at[i])
          nickname.destroy_all if nickname.present?
        end
      end
    end

    puts "=== Suikoden Database Destrunction: END ==="
  end
end
# rubocop:enable Layout/IndentationConsistency

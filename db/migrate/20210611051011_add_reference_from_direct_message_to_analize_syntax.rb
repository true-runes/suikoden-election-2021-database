class AddReferenceFromDirectMessageToAnalizeSyntax < ActiveRecord::Migration[6.1]
  def change
    add_reference :analyze_syntaxes, :direct_message
  end
end

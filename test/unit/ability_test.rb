require 'test_helper'

class AbilityTest < ActiveSupport::TestCase
  test "el rol admin puede administrar todo" do
    user = admin_users(:admin)
    ability = Ability.new(user)
    assert ability.can?(:create, :all), "Admin tiene permiso a todo"
  end

  test "solo el rol mesa de entrada puede administrar notas." do
    user = admin_users(:gallego)
    ability = Ability.new(user)
    assert ability.can?([:create,:update], Nota), "mesa de entrada si puede crear notas"
    assert ability.can?([:create,:update], Pase), "mesa de entrada si puede crear pases"
    assert ability.can?([:create,:update], Area), "mesa de entrada si puede crear areas"

    other = admin_users(:other)
    ability = Ability.new(other)
    assert ability.cannot?([:create,:update], Nota), "no puede crear notas"
    assert ability.cannot?([:create,:update], Pase), "no puede crear pases"
    assert ability.cannot?([:create,:update], Area), "no puede crear aresas"
  end
end

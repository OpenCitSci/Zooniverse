$ = require 'jqueryify'
User = require '../models/user'
Controller = require './controller'
templates = require '../views/login_form'

class BaseForm extends Controller
  events:
    sumbit: 'onSubmit'
    keydown: 'onInputChange'
    change: 'onInputChange'

  elements:
    '.errors': 'errors'
    'input[name="username"]': 'usernameField'
    'input[name="email"]': 'emailField'
    'input[name="password"]': 'passwordField'
    'input[name="password-confirm"]': 'passwordConfirmField'
    'input[name="policy"]': 'submitButton'
    'button[type="submit"]': 'submitButton'
    '.progress': 'progress'
    'input[required]': 'requiredInputs'

  constructor: ->
    super
    @html @template

    User.bind 'signed-in', @onSignIn

  onSubmit: (e) =>
    @errors.hide()
    @errors.empty()

    @progress.show()

  onError: (error) =>
    @progress.hide()

    @errors.append error
    @errors.show()

  onInputChange: =>
    # Only allow submit if all items are filled out
    setTimeout =>
      allFilledIn = Array::every.call @requiredInputs, (el) ->
        if el.type is 'checkbox'
          el.checked
        else
          !!el.value

      @submitButton.attr disabled: not allFilledIn

  onSignIn: =>
    @progress.hide()

class SignInForm extends BaseForm
  className: 'sign-in'
  template: templates.signIn

  onSubmit: =>
    super

    console.log 'here ;laksjdf;laskdjf;alsdkfja;sldfjk;'
    console.log User.current

    login = User.login
      username: @usernameField.val()
      password: @passwordField.val()

    login.fail @onError

class SignUpForm extends BaseForm
  className: 'sign-up'
  template: templates.signUp

  onSubmit: =>
    super

    unless @passwordField.val() is @passwordConfirmField.val()
      @onError 'Passwords must match!'
      @passwordField.focus()
      return

    signup = User.signup
      username: @usernameField.val()
      password: @passwordField.val()
      email: @emailField.val()

    signup.fail @onError

class SignOutForm extends BaseForm
  className: 'sign-out'
  template: templates.signOut

  onSubmit: =>
    super
    User.logout()

  onSignIn: =>
    super
    @el.find('.current').html User.current?.name || ''

module.exports = 
  BaseForm: BaseForm
  SignInForm: SignInForm
  SignUpForm: SignUpForm
  SignOutForm: SignOutForm
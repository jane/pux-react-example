"use strict"

// module App.Counter

const React = require("react")
const r = require("r-dom")
const Pux = require("purescript-pux")
const Actions = require("../App")

const PuxProvider = React.createClass({
  childContextTypes: {
    puxStore: React.PropTypes.object.isRequired
  },
  getChildContext: function() {
    return {puxStore: this.props.store}
  },
  render: function() {
    return React.Children.only(
      this.props.children
        && this.props.children[0]
    )
  }
})

exports.puxProviderImpl = Pux.fromReact(PuxProvider)

exports.jsApp = Pux.fromReact(React.createClass({
  contextTypes: {
    puxStore: React.PropTypes.object.isRequired
  },
  increment: function() {
    this.context.puxStore.channel.set(
      Actions.increment()
    )
  },
  decrement: function() {
    this.context.puxStore.channel.set(
      Actions.decrement()
    )
  },
  reset: function() {
    this.context.puxStore.channel.set(
      Actions.reset()
    )
  },
  textInput: function(e) {
    this.context.puxStore.channel.set(
      Actions.textInput(e.target.value)
    )
  },
  render: function () {
    const state = this.context.puxStore.state
    return (
      r.div([
        r.div([
          r.button({onClick: this.increment}, "Increment"),
          r.span(
            {style: {marginLeft: 10, marginRight: 10}},
            String(state.count)
          ),
          r.button({onClick: this.decrement}, "Decrement")
        ]),
        r.button({onClick: this.reset}, "Reset"),
        r.div([
          r.textarea({onInput: this.textInput, value: state.text}),
          r.p(state.text)
        ])
      ])
    )
  }
}))

var Main = require('../src/Main.purs');
var initialState = Main.init();
var debug = process.env.WEBPACK_ENV === 'dev'

if (module.hot) {
	var app = Main[debug ? 'debug' : 'main'](window.puxLastState || initialState)();
	app.state.subscribe(function (state) {
	 window.puxLastState = state;
	});
	module.hot.accept();
} else {
	Main[debug ? 'debug' : 'main'](initialState)();
}

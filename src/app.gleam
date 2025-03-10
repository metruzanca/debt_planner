import debt
import gleam/bool
import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import lustre
import lustre/attribute.{class}
import lustre/element
import lustre/element/html.{button, div, p, text}
import lustre/event
import tardis
import ui
import utils

// get budget per payment period
// get debt list

// sort debts depending on strategy
// calculate payment plan:
// - each payment group must at least meet minimum payment
// - then must maximize either smallest/biggest depending on strategy
pub fn main() {
  let assert Ok(main) = tardis.single("main")
  lustre.simple(init, update, view)
  |> tardis.wrap(with: main)
  |> lustre.start("#app", Nil)
  |> tardis.activate(with: main)
}

pub type Model {
  Model(debts: List(debt.Debt))
}

fn init(_flags) {
  Model(debts: [debt.create(0)])
}

pub type Msg {
  AddDebt
  RemoveDebt(index: Int)

  // Inputs
  OnChangeName(id: Int, value: String)
  OnChangeAmount(id: Int, value: Float)
  OnChangeInterest(id: Int, value: Float)
  OnChangeTotal(id: Int, value: Float)
}

// TODO tardis dev tools
fn update(model: Model, msg: Msg) -> Model {
  let len = list.length(model.debts)
  case msg {
    AddDebt -> Model(debts: list.append(model.debts, [debt.create(len)]))
    RemoveDebt(index) -> Model(debts: utils.remove_at(model.debts, index))
    OnChangeAmount(id, amount) -> {
      io.debug(id)
      io.debug(amount)
      // TODO probably better to make debts a dict or update this better
      Model(
        debts: list.map(model.debts, fn(value) {
          use <- bool.guard(id == value.id, value)
          debt.Debt(..value, amount:)
        }),
      )
    }
    OnChangeInterest(_, _) -> todo
    OnChangeName(_, _) -> todo
    OnChangeTotal(_, __) -> todo
    _ -> model
  }
  |> io.debug
}

fn view(model: Model) {
  // let count = int.to_string(model)

  html.main([class("h-screen w-full flex justify-center p-4")], [
    html.div([], [
      div([class("w-full flex justify-between")], [
        div([], [
          ui.select([], [
            html.option(
              [attribute.selected(True), attribute.value("smallest")],
              "Smallest",
            ),
            html.option([attribute.value("biggest")], "Biggest"),
          ]),
        ]),
        ui.button([event.on_click(AddDebt)], [text("+")]),
      ]),
      element.keyed(div([class("flex flex-col")], _), {
        use current, index <- list.index_map(model.debts)
        let item = debt_input(current, index)

        #(int.to_string(current.id), item)
      }),
    ]),
  ])
}

fn debt_input(model: debt.Debt, i: Int) {
  // let handle_input = fn(e) {
  //   event.value(e)
  // https://hexdocs.pm/lustre/guide/06-full-stack-applications.html
  //   |> result.nil_error // nil_error is not in stdlib anymore. No clue what it did.
  //   |> result.then(float.parse)
  //   |> result.map(OnChangeAmount(model.id, _))
  //   |> result.replace_error([])
  // }

  div([class("flex"), attribute.id(int.to_string(model.id))], [
    ui.input([attribute.placeholder("Name"), attribute.value(model.name)]),
    ui.input([
      attribute.type_("number"),
      attribute.placeholder("Amount"),
      attribute.value(float.to_string(model.amount)),
      event.on_input(fn(x) {
        // lol, if I you try to parse  4 to float, it fails because it needs to be 4.0
        let assert Ok(x) = int.parse(x)
        let x = int.to_float(x)

        OnChangeAmount(model.id, x)
      }),
    ]),
    ui.input([
      attribute.type_("number"),
      attribute.placeholder("Interest"),
      attribute.value(float.to_string(model.interest)),
    ]),
    ui.input([
      attribute.type_("number"),
      attribute.placeholder("Minimum"),
      attribute.value(float.to_string(model.minimum)),
    ]),
    ui.button([attribute.disabled(i == 0), event.on_click(RemoveDebt(i))], [
      text("-"),
    ]),
  ])
}

import debt
import gleam/int
import gleam/io
import gleam/list
import lustre
import lustre/attribute
import lustre/element/html.{button, div, p, text}
import lustre/event
import ui
import utils

// get budget per payment period
// get debt list

// sort debts depending on strategy
// calculate payment plan:
// - each payment group must at least meet minimum payment
// - then must maximize either smallest/biggest depending on strategy
pub fn main() {
  let app = lustre.simple(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}

type Model {
  Model(debts: List(debt.Debt))
}

fn init(_flags) {
  Model(debts: [debt.create()])
}

type Msg {
  AddDebt
  RemoveDebt(index: Int)
}

// TODO tardis dev tools
fn update(model: Model, msg: Msg) -> Model {
  let Model(m) = model

  io.debug(m)
  case msg {
    AddDebt -> Model(debts: list.append(m, [debt.create()]))
    RemoveDebt(index) -> Model(debts: utils.remove_at(m, index))
  }
  |> io.debug
}

fn view(model: Model) {
  // let count = int.to_string(model)
  let Model(debts) = model

  div([attribute.class("h-screen w-full flex items-center justify-center")], [
    html.div([], [
      div([attribute.class("w-full flex justify-between")], [
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
      div(
        [attribute.class("flex flex-col")],
        list.index_map(debts, fn(debt, i) {
          div([attribute.class("flex")], [
            debt_input(debt),
            ui.button([event.on_click(RemoveDebt(i))], [text("-")]),
          ])
        }),
      ),
    ]),
  ])
}

fn debt_input(model: debt.Debt) {
  div([], [
    ui.input([attribute.placeholder("Name"), attribute.value(model.name)]),
    ui.input([attribute.placeholder("Amount")]),
    ui.input([attribute.placeholder("Interest")]),
    ui.input([attribute.placeholder("Minimum")]),
  ])
}

import debt
import gleam/bool
import gleam/int
import gleam/list
import gleam/result
import glentities
import lustre
import lustre/attribute.{class}
import lustre/element
import lustre/element/html.{div, text}
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
  OnChangeAmount(id: Int, value: String)
  OnChangeInterest(id: Int, value: String)
  OnChangeMinimum(id: Int, value: String)
  Noop
}

// TODO tardis dev tools
fn update(model: Model, msg: Msg) -> Model {
  let len = list.length(model.debts)
  case msg {
    AddDebt -> Model(debts: list.append(model.debts, [debt.create(len)]))
    RemoveDebt(index) -> Model(debts: utils.remove_at(model.debts, index))
    OnChangeAmount(id, value) ->
      Model(
        debts: list.map(model.debts, fn(item) {
          use <- bool.guard(id != item.id, item)
          let value = result.unwrap(int.parse(value), 0)
          debt.Debt(..item, amount: value)
        }),
      )

    OnChangeInterest(id, value) ->
      Model(
        debts: list.map(model.debts, fn(item) {
          use <- bool.guard(id != item.id, item)
          let value = result.unwrap(int.parse(value), 0)
          debt.Debt(..item, interest: value)
        }),
      )
    OnChangeName(id, value) ->
      Model(
        debts: list.map(model.debts, fn(item) {
          use <- bool.guard(id != item.id, item)
          debt.Debt(..item, name: value)
        }),
      )
    OnChangeMinimum(id, value) ->
      Model(
        debts: list.map(model.debts, fn(item) {
          use <- bool.guard(id != item.id, item)
          let value = result.unwrap(int.parse(value), 0)
          debt.Debt(..item, minimum: value)
        }),
      )
    _ -> model
  }
  // |> io.debug()
}

fn view(model: Model) {
  // let count = int.to_string(model)

  html.main(
    [class("h-screen w-full flex justify-center p-4"), keybinds(model)],
    [
      html.div([], [
        // Strategy Select
        html.label([class("flex")], [
          text("Strategy:\u{a0}"),
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
        ]),
        // Debt inputs
        element.keyed(div([class("flex flex-col")], _), {
          use current, index <- list.index_map(model.debts)
          let item = debt_input(current, index, list.length(model.debts))

          #(int.to_string(current.id), item)
        }),
        html.hr([class("my-4")]),
        // Payments table
        ui.table([text("First"), text("Second")], [
          [text("aaa"), text("bbb")],
          [text("ccc"), text("ddd")],
        ]),
        // html.table([class("border")], [
      //   html.thead([class("border")], [
      //     html.th([class("p-2")], [text("First")]),
      //     html.th([class("p-2")], [text("Second")]),
      //   ]),
      //   html.tbody([], [
      //     html.tr([], [
      //       html.td([class("p-2")], [text("aaaaa")]),
      //       html.td([class("p-2")], [text("bbbbb")]),
      //     ]),
      //   ]),
      // ]),
      ]),
    ],
  )
}

/// Global keyboard shortcuts
fn keybinds(model: Model) {
  event.on_keydown(fn(key) {
    case key {
      "Enter" -> AddDebt
      _ -> Noop
    }
  })
}

fn debt_input(debt: debt.Debt, i: Int, len: Int) {
  // let handle_input = fn(e) {
  //   event.value(e)
  // https://hexdocs.pm/lustre/guide/06-full-stack-applications.html
  //   |> result.nil_error // nil_error is not in stdlib anymore. No clue what it did.
  //   |> result.then(float.parse)
  //   |> result.map(OnChangeAmount(model.id, _))
  //   |> result.replace_error([])
  // }

  let handle_input = fn(constructor) { constructor(debt.id, _) }

  div([class("flex"), attribute.id(int.to_string(debt.id))], [
    ui.input([
      attribute.placeholder("Name"),
      attribute.value(debt.name),
      attribute.value(debt.name),
      event.on_input(handle_input(OnChangeName)),
    ]),
    ui.input([
      attribute.type_("number"),
      attribute.placeholder("Amount"),
      attribute.value(int.to_string(debt.amount)),
      event.on_input(handle_input(OnChangeAmount)),
    ]),
    ui.input([
      attribute.type_("number"),
      attribute.placeholder("Interest"),
      attribute.value(int.to_string(debt.interest)),
      event.on_input(handle_input(OnChangeInterest)),
    ]),
    ui.input([
      attribute.type_("number"),
      attribute.placeholder("Minimum"),
      attribute.value(int.to_string(debt.minimum)),
      event.on_input(handle_input(OnChangeMinimum)),
    ]),
    ui.button([attribute.disabled(len == 1), event.on_click(RemoveDebt(i))], [
      text("-"),
    ]),
  ])
}
// TODO how to add global keyboard events? e.g. window.addEventListe`r('keyup', ...) equivalent

export class Day {
  id: string
  name: string
  tasks: any[]
  isInteractive: boolean
  price: any | null
  result: any | null

  constructor(id: string, name: string) {
    this.id = id
    this.name = name
    this.tasks = []
    this.isInteractive = true
    this.price = null
    this.result = null
  }
}
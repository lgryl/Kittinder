// Created 21/12/2020

import Foundation

class AsynchronousOperation: Operation {
    enum State: String {
        case ready
        case executing
        case finished

        fileprivate var keyPath: String {
            "is" + rawValue.capitalized
        }
    }

    var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
}

extension AsynchronousOperation {
    override var isReady: Bool {
        super.isReady && state == .ready
    }

    override var isExecuting: Bool {
        state == .executing
    }

    override var isFinished: Bool {
        state == .finished
    }

    override var isAsynchronous: Bool {
        true
    }

    override func start() {
        guard !isCancelled else {
            state = .finished
            return
        }
        state = .executing
        main()
    }

    override func cancel() {
        super.cancel()
        state = .finished
    }
}

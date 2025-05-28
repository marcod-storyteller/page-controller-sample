import UIKit

class DrawingViewController: UIViewController {
    private var currentPath: UIBezierPath?
    private var currentLayer: CAShapeLayer?

    let drawingView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupDrawingView()
        setupPanGesture()
    }

    private func setupDrawingView() {
        drawingView.backgroundColor = .white

        view.addSubview(drawingView)
        drawingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            drawingView.topAnchor.constraint(equalTo: view.centerYAnchor),
            drawingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            drawingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            drawingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        drawingView.addGestureRecognizer(panGesture)
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let point = gesture.location(in: drawingView)

        switch gesture.state {
        case .began:
            startDrawing(at: point)
        case .changed:
            updateDrawing(to: point)
        default:
            break
        }
    }

    private func startDrawing(at point: CGPoint) {
        currentPath = UIBezierPath()
        currentPath?.move(to: point)

        currentLayer = CAShapeLayer()
        currentLayer?.path = currentPath?.cgPath
        currentLayer?.strokeColor = UIColor.black.cgColor
        currentLayer?.fillColor = UIColor.clear.cgColor
        currentLayer?.lineWidth = 3
        currentLayer?.lineCap = .round

        if let currentLayer {
            drawingView.layer.addSublayer(currentLayer)
        }
    }

    private func updateDrawing(to point: CGPoint) {
        currentPath?.addLine(to: point)
        currentLayer?.path = currentPath?.cgPath
    }
}

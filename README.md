# Pet Circle Demo

This project is my submission for Pet Circle's technical challenge for the QA and Test Engineer role. It contains automated API tests using Robot Framework and RequestsLibrary.

## Project Structure

- `requirements.txt`: Lists dependencies
- `keywords/pets/Pets.resource`: Contains reusable Robot Framework keywords for common API operations
- `tests/pets/`: Directory containing individual test suites for different API endpoints:
  - `AddPets.robot`: Tests for adding new pets.
  - `FindPets.robot`: Tests for retrieving pet information.
  - `UpdatePets.robot`: Tests for updating existing pet details.
  - `DeletePets.robot`: Tests for deleting pets.
- `.github/workflows/robot.yaml`: Workflow to run tests on `push` events to the `main` branch.
- `Dockerfile`: Defines the Docker image

## Getting Started

### Prerequisites

- Python 3.x and pip
- (Optional) Docker (for containerized test execution)

### Running Tests

#### Locally

1. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
2. Run the tests:
   ```bash
   robot -d results tests/
   ```

#### (Optional) Using Docker

1. Build the Docker image:
   ```bash
   docker build -t petcircle-robot-tests .
   ```
2. Run the tests:
   ```bash
   docker run petcircle-robot-tests
   ```
   Test results will be generated in the `results/` directory within the container. You can mount a local volume to persist these results:
   ```bash
   docker run -v "$(pwd)/results:/app/results" petcircle-robot-tests
   ```

### GitHub Actions

The project includes a GitHub Actions workflow (`.github/workflows/robot.yaml`) that automatically runs the tests on every push to the `main` branch. The workflow also attempts to rerun failed tests and merges the results. Test reports are uploaded as artifacts.

## Notes/Observations During Testing

- Some fields don't seem to have the expected validations based on the API spec.
- The `PUT` and `DELETE` endpoints don't seem to update/delete the resources as expected.
- The response body for some 4xx responses don't seem to have descriptive error messages or content. Some error messages even expose the underlying tech stack/architecture.
- Repeatedly sending the same request for some endpoints (e.g., `GET`) seems to produce different response bodies every time.

## Ideas for Improvement

- Add more comprehensive test cases for each endpoint, covering all fields (e.g., `category`, `tags`) and various valid/invalid data combinations and field validations, as well as validations for expected HTTP methods and headers.
- Add tests for other API endpoints (e.g., `store`, `user`).
- Define other common setup/teardown, user flow, and assertion logic as reusable keywords.
- Explore using data-driven/test template approach for scenarios with many input variations.
- The Pet Store API only has one base URL but if there were other environments, explore configuring env files and parameterization to be able to run tests more conveniently on different environments.
- If sensitive data is involved, explore configuring them into env files as well.
- Explore test data randomization (e.g, `robotframework-faker`)
- Explore parallel test execution (https://docs.robotframework.org/docs/parallel)
- Implement more consistent coding standards (e.g., https://docs.robotframework.org/docs/style_guide, or internal project/team standards)

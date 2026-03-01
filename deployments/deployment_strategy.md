## Strategy

`.spec.strategy` specifies the strategy used to replace old pods with new ones. `.spec.strategy.type` can be **RollingUpdate** or **Recreate**. RollingUpdate is the default one.

- **RollingUpdate:** Replaces old pods running the old version of the application with the  new version, one by one, without taking the cluster down.

- The deployments update pod in rolling update fashion when `.spec.strategy.type=RollingUpdate.`
  

   ```bash
    

   ```

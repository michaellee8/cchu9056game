using System.Linq;
using UnityEngine;

public class ConvexConfigurator : MonoBehaviour
{
    private void OnEnable()
    {
        foreach (var t1 in FindObjectsOfType(typeof(Component)).ToList().Select(stat => ((Component)stat).gameObject).TakeWhile(t => !t.CompareTag("NotConvex")).Select(t => t.GetComponentsInChildren<MeshCollider>(true))
                     .SelectMany(allComponents => allComponents)) t1.convex = true;
    }
}

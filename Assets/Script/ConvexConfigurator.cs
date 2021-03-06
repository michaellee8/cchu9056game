using System.Linq;
using UnityEngine;

public class ConvexConfigurator : MonoBehaviour
{
    private void OnEnable()
    {
        var a = FindObjectsOfType(typeof(Component)).ToList().Select(stat => ((Component)stat).gameObject).TakeWhile(t => !t.CompareTag("NotConvex"));
        
        print("running");
        foreach (var t1 in FindObjectsOfType(typeof(Component)).ToList().Select(stat => ((Component)stat).gameObject).TakeWhile(t => !t.CompareTag("NotConvex")).Select(t => t.GetComponentsInChildren<MeshCollider>(true))
                     .SelectMany(allComponents => allComponents).TakeWhile(t => !t.convex))
        {
            print("Changing " + t1.name + "to convex.");
            t1.convex = true;
        }
    }
}

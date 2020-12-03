using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

[RequireComponent(typeof(Light))]
public class LightEditor : MonoBehaviour
{


    GameObject lookat;

    Light light;

    Light Light
    {
        get
        {
            if (light == null)
                light = GetComponent<Light>();
            return light;
        }
    }

    //GameObject Target
    //{
    //    get
    //    {
    //        if (lookat == null)
    //        {
    //            target = new GameObject();
    //            lookat.transform.position = target + transform.forward * 10;
    //        }
    //        return target;

    //    }
    //}

    private void OnDrawGizmos()
    {

        if (lookat == null)
        {
            lookat = GameObject.CreatePrimitive(PrimitiveType.Sphere);
            lookat.transform.position = transform.position + transform.forward * 10;
            lookat.hideFlags = HideFlags.HideAndDontSave;
        }
        transform.LookAt(lookat.transform);

        Gizmos.color = Light.color;
        Gizmos.DrawLine(transform.position, lookat.transform.position);

        





    }

}
